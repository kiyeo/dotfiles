#!/usr/bin/env bash

display_help() {
    echo "Leo Keo"
    echo
    echo "My personal configuration/settings for development"
    echo
    echo "WARNING: Don’t blindly use my settings unless you know what that entails. Use at your own risk!"
    echo "Please examine the script before running!"
    echo
    echo "Project home page: https://github.com/kiyeo/dotfiles"
    echo
    echo "USAGE:"
    echo "  $0 [OPTIONS] <ARGUMENTS>"
    echo "  $0 -h"
    echo "  $0 --help"
    echo "  $0 -t"
    echo "  $0 --tex"
    echo
    echo "OPTION:"
    echo "  -h, --help                   Prints help information."
    echo "  -f, --font <BOOLEAN>    To install font. [Default: true]"
    echo "                          E.g. -f false | --font false"
    echo "  -n, --nvm  <BOOLEAN>    To install NVM (NodeJS). [Default: true]"
    echo "                          E.g. -n false | --node false"
    echo "  -t, --tex  <BOOLEAN>    To install TeXpresso dependencies. [Default: false]"
    echo "                          E.g. -t true | --tex true"
    echo
    echo "ARGUMENTS:"
    echo "  <BOOLEAN>     true or false. true | false"
    echo
}

is_install_font=true
is_install_nvm=true
is_install_tex=false
tex_apt_packages=" latexmk texlive-xetex fonts-linuxlibertine"
tex_brew_packages=" mactex font-linux-libertine"
texpresso_apt_packages=" build-essential libsdl2-dev libmupdf-dev libmujs-dev libfreetype-dev  libgumbo-dev libjbig2dec0-dev libjpeg-dev libopenjp2-7-dev cargo libssl-dev libfontconfig-dev libleptonica-dev libharfbuzz-dev"
texpresso_brew_packages=" rust mupdf-tools SDL2"

while [[ "$#" -gt 0 ]]; do
  case "$1" in
    -h | --help)
        display_help
        exit 0
        ;;
    -f | --font)
        is_install_font=$2
        shift
        ;;
    -n | --nvm)
        is_install_nvm=$2
        shift
        ;;
    -t | --tex)
        is_install_tex=$2
        shift
        ;;
    *)
        echo "Unknown option passed: $1"
        echo
        display_help
        exit 1
        ;;
  esac
  shift
done

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
        if [ "$is_install_tex" = true ]; then
          apt_packages+=${tex_apt_packages}
          apt_packages+=${texpresso_apt_packages}
        fi
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
    if [ "$is_install_tex" = true ]; then
      brew_packages+=${tex_brew_packages}
      brew_packages+=${texpresso_brew_packages}
    fi
    brew install ${brew_packages}
    ;;
esac

if [ "$is_install_font" = true ]; then
  wget -NP ~/.local/share/fonts/ 'https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/JetBrainsMono/Ligatures/Regular/JetBrainsMonoNerdFont-Regular.ttf'
fi

if [ "$is_install_nvm" = true ]; then
  curl -o- https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
  nvm install node
fi

if [ "$is_install_tex" = true ]; then
  if [ ! -d "/tmp/texpresso" ]; then
    git clone --recurse-submodules https://github.com/let-def/texpresso.git /tmp/texpresso
  fi
  make -C /tmp/texpresso &&
    cp -r /tmp/texpresso/build ~/.local/bin
fi

if [ "${PWD##*/}" != "dotfiles" ]; then
  if [ ! -d "dotfiles" ]; then
    git clone https://github.com/kiyeo/dotfiles.git
  fi
  cd dotfiles
fi

git submodule update --init --recursive --remote

stow --no-folding */

chsh -s "$(command -v zsh)"
exec "$(command -v zsh)"
