#!/usr/bin/env bash

set -e

os_type="$(uname -s)"

apt_packages="zsh stow git neovim ripgrep"
brew_packages="zsh stow git neovim ripgrep"

case "$os_type" in
  Linux*)
    sudo apt-get update && sudo apt-get install -y ${apt_packages}
    ;;
  Darwin*)
    brew install ${brew_packages}
    ;;
esac

chsh -s "$(command -v zsh)"

git submodule update --init --recursive --remote

stow */

nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync' # https://github.com/wbthomason/packer.nvim/issues/502
