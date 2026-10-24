#!/bin/bash
DOTFILES="$(cd "$(dirname "$0")" && pwd)"

# --- Symlinks ---
rm -f ~/.bashrc
rm -f ~/.config/nvim
rm -f ~/.wezterm.lua
mkdir -p ~/.config
ln -s "$DOTFILES/.bashrc" ~/.bashrc
ln -s "$DOTFILES/nvim" ~/.config/nvim
ln -s "$DOTFILES/.wezterm.lua" ~/.wezterm.lua

echo "Symlinks created."

# --- Dependencies ---
# Maps command -> apt package name
# (prettier via npm and dotnet via dynamic resolution are handled separately)
declare -A deps=(
  [batcat]="bat"
  [nvim]="neovim"
  [rg]="ripgrep"
  [xclip]="xclip"
  [tree]="tree"
  [git]="git"
  [bats]="bats"
  [gcc]="build-essential"
)

missing=()
for cmd in "${!deps[@]}"; do
  which "$cmd" > /dev/null 2>&1 || missing+=("$cmd")
done

# prettier is installed via npm, not apt
prettier_missing=false
which prettier > /dev/null 2>&1 || prettier_missing=true

# dotnet: resolve the latest available dotnet-sdk-N.N package dynamically
dotnet_missing=false
dotnet_pkg=""
if ! which dotnet > /dev/null 2>&1; then
  dotnet_missing=true
  dotnet_pkg=$(apt-cache search '^dotnet-sdk-[0-9]' 2>/dev/null \
    | awk '{print $1}' \
    | grep -E '^dotnet-sdk-[0-9]+\.[0-9]+$' \
    | sort -V \
    | tail -n 1)
fi

if [[ ${#missing[@]} -eq 0 ]] && [[ $prettier_missing == false ]] && [[ $dotnet_missing == false ]]; then
  echo "All dependencies already installed."
else
  echo ""
  echo "The following dependencies are missing:"
  for cmd in "${missing[@]}"; do
    echo "  - $cmd (${deps[$cmd]})"
  done
  [[ $prettier_missing == true ]] && echo "  - prettier (via npm)"
  [[ $dotnet_missing == true ]] && echo "  - dotnet (${dotnet_pkg:-no dotnet-sdk package found})"
  echo ""
  read -rp "Install missing dependencies? [y/N] " confirm
  if [[ $confirm =~ ^[Yy]$ ]]; then
    sudo apt update
    for cmd in "${missing[@]}"; do
      sudo apt install -y "${deps[$cmd]}"
    done
    if [[ $prettier_missing == true ]]; then
      sudo apt install -y nodejs npm
      sudo npm install -g prettier
    fi
    if [[ $dotnet_missing == true ]] && [[ -n $dotnet_pkg ]]; then
      sudo apt install -y "$dotnet_pkg"
    fi
    echo "Done."
  else
    echo "Skipped. Install manually to achieve full parity."
  fi
fi

echo ""
echo "Setup complete. Restart your shell or run: source ~/.bashrc"
echo ""
echo "NOTE: On the first Neovim launch, give plugins and treesitter parsers a few"
echo "seconds to finish installing before opening files. A transient 'No parser for"
echo "language ...' warning on first open is normal and resolves once compilation finishes."
echo ""

# --- Windows Terminal Tron Background Setup (WSL only) ---
if grep -qi microsoft /proc/version 2>/dev/null; then
  echo "=== Windows Terminal Background Setup ==="
  
  # Get Windows username
  WIN_USER=$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r\n' | tr -d ' ')
  
  if [[ -n $WIN_USER ]]; then
    # Create background directory
    BG_DIR="/mnt/c/Users/$WIN_USER/Pictures/nvim_backgrounds"
    mkdir -p "$BG_DIR"
    
    # Download Tron grid wallpaper if it doesn't exist
    if [[ ! -f "$BG_DIR/tron_grid.jpg" ]]; then
      echo "Downloading Tron grid wallpaper..."
      curl -L -o "$BG_DIR/tron_grid.jpg" 'https://images.unsplash.com/photo-1550745165-9bc0b252726f?w=1920&h=1080&fit=crop' 2>/dev/null
    fi
    
    # Configure Windows Terminal settings
    WT_SETTINGS="/mnt/c/Users/$WIN_USER/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"
    
    if [[ -f $WT_SETTINGS ]]; then
      echo "Configuring Windows Terminal background..."
      
      # Backup existing settings
      cp "$WT_SETTINGS" "${WT_SETTINGS}.bak"
      
      # Add Tron background using Python
      python3 << EOF
import json
import sys

try:
    with open("$WT_SETTINGS", 'r') as f:
        settings = json.load(f)
    
    # Add Tron background to defaults
    if 'profiles' not in settings:
        settings['profiles'] = {}
    if 'defaults' not in settings['profiles']:
        settings['profiles']['defaults'] = {}
    
    settings['profiles']['defaults']['backgroundImage'] = "C:/Users/$WIN_USER/Pictures/nvim_backgrounds/tron_grid.jpg"
    settings['profiles']['defaults']['backgroundImageOpacity'] = 0.5
    settings['profiles']['defaults']['backgroundImageStretchMode'] = "uniformToFill"
    
    with open("$WT_SETTINGS", 'w') as f:
        json.dump(settings, f, indent=4)
    
    print("✓ Tron background configured")
    print("  Restart Windows Terminal to see changes")
except Exception as e:
    print(f"✗ Failed to configure background: {e}", file=sys.stderr)
    sys.exit(1)
EOF
    else
      echo "✗ Windows Terminal settings not found - configure manually"
    fi
  fi
fi
