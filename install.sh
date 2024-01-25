#!/usr/bin/env bash

set -e

os_type="$(uname -s)"

emerge_packages="x11-misc/picom x11-apps/xsetroot x11-misc/xclip media-gfx/feh media-plugins/alsa-plugins media-sound/alsa-utils app-shells/zsh dev-vcs/git app-admin/stow app-editors/neovim sys-apps/ripgrep app-shells/zoxide sys-process/htop app-misc/neofetch"
apt_packages="git zsh stow neovim ripgrep zoxide gcc"
brew_packages="git zsh stow neovim ripgrep zoxide gcc"

case "$os_type" in
  Linux*)
    distributor_id="$(lsb_release --short --id)"
    case "$distributor_id" in
      Ubuntu)
        sudo apt-get update
        sudo apt-get install -y ${apt_packages}
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

wget "https://github.com/git-ecosystem/git-credential-manager/releases/download/v2.4.1/gcm-linux_amd64.2.4.1.deb" -O /tmp/gcmcore.deb
sudo dpkg -i /tmp/gcmcore.deb

wget -NP ~/.local/share/fonts/ 'https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/JetBrainsMono/Ligatures/Regular/JetBrainsMonoNerdFont-Regular.ttf'

curl -o- https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm install node

if [ "${PWD##*/}" != "dotfiles" ]; then
  if [ ! -d "dotfiles" ]; then
    git clone https://github.com/kiyeo/dotfiles.git
  fi
  cd dotfiles
fi

git submodule update --init --recursive --remote

stow --no-folding */

git-credential-manager configure

chsh -s "$(command -v zsh)"
exec "$(command -v zsh)"
