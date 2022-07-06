#!/usr/bin/env bash

set -e

os_type="$(uname -s)"

emerge_packages="dev-vcs/git app-shells/zsh app-admin/stow app-editors/neovim sys-apps/ripgrep app-shells/zoxide sys-process/htop app-misc/neofetch x11-misc/xclip"
apt_packages="git zsh stow neovim ripgrep zoxide gcc"
brew_packages="git zsh stow neovim ripgrep zoxide gcc"

case "$os_type" in
  Linux*)
    distributor_id="$(lsb_release --short --id)"
    case "$distributor_id" in
      Ubuntu)
        sudo apt-get update && sudo apt-get install -y ${apt_packages}
	      ;;
      Gentoo)
        sudo eselect repository enable guru
        sudo emerge --sync guru
        sudo emerge --ask --verbose --changed-use ${emerge_packages}
	      ;;
    esac
    ;;
  Darwin*)
    brew install ${brew_packages}
    ;;
esac

chsh -s "$(command -v zsh)"

curl -o- https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
. $NVM_DIR/nvm.sh
nvm install node

if [ "${PWD##*/}" != "dotfiles" ]; then
  if [ ! -d "dotfiles" ]; then
    git clone git@github.com:kiyeo/dotfiles.git
  fi
  cd dotfiles
fi

git submodule update --init --recursive --remote

stow */

nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync' # https://github.com/wbthomason/packer.nvim/issues/502
