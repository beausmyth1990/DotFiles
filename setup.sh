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
declare -A deps=(
  [batcat]="bat"
  [nvim]="neovim"
  [rg]="ripgrep"
  [xclip]="xclip"
  [tree]="tree"
  [git]="git"
  [prettier]="prettier"
  [bats]="bats"
)

missing=()
for cmd in "${!deps[@]}"; do
  which "$cmd" > /dev/null 2>&1 || missing+=("$cmd")
done

if [[ ${#missing[@]} -eq 0 ]]; then
  echo "All dependencies already installed."
else
  echo ""
  echo "The following dependencies are missing:"
  for cmd in "${missing[@]}"; do
    echo "  - $cmd (${deps[$cmd]})"
  done
  echo ""
  read -rp "Install missing dependencies via apt? [y/N] " confirm
  if [[ $confirm =~ ^[Yy]$ ]]; then
    sudo apt update
    for cmd in "${missing[@]}"; do
      sudo apt install -y "${deps[$cmd]}"
    done
    echo "Done."
  else
    echo "Skipped. Install manually to achieve full parity."
  fi
fi

echo ""
echo "Setup complete. Restart your shell or run: source ~/.bashrc"
