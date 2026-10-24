#!/bin/bash
DOTFILES="$(cd "$(dirname "$0")" && pwd)"

# --- Symlinks ---
rm -f ~/.bashrc
rm -f ~/.config/nvim
mkdir -p ~/.config
ln -s "$DOTFILES/.bashrc" ~/.bashrc
ln -s "$DOTFILES/nvim" ~/.config/nvim

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

# --- Treesitter Parser Warm-up ---
# Precompile treesitter parsers to avoid first-launch race condition
if which nvim > /dev/null 2>&1; then
  echo ""
  echo "Precompiling treesitter parsers..."
  # Install all parsers that LazyVim declares in ensure_installed
  # This runs synchronously and waits for compilation to complete
  # Redirect stderr to suppress LSP/omnisharp errors from headless config loading
  nvim --headless -c 'TSInstall! bash c diff html javascript jsdoc json lua luadoc markdown markdown_inline python query regex toml tsx typescript vim vimdoc xml yaml c_sharp' -c 'sleep 30' -c 'qa' 2>/dev/null | grep -E '(nvim-treesitter.*Installed|Language installed)' || true
  echo "Parser warm-up complete."
fi

echo ""
echo "Setup complete. Restart your shell or run: source ~/.bashrc"
