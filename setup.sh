#!/bin/bash
# Run once after cloning to set up symlinks
DOTFILES="$(cd "$(dirname "$0")" && pwd)"

ln -sf "$DOTFILES/.bashrc" ~/.bashrc
mkdir -p ~/.config
ln -sf "$DOTFILES/nvim" ~/.config/nvim

echo "Done. Restart your shell or run: source ~/.bashrc"
