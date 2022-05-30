# dotfiles

```
git clone https://github.com/Kiyeo/dotfiles.git &&
  cd dotfiles &&
  ./install.sh &&
  zsh
```
## submodule updates
```
git submodule update --recursive --remote
```
## uninstall dotfiles
```
cd dotfiles &&
  stow -D */
```
## Clipboard
In init.vim or .vimrc put set `clipboard=unnamedplus`.

Execute the following commands:

```
curl -sLo /tmp/win32yank.zip https://github.com/equalsraf/win32yank/releases/download/v0.0.4/win32yank-x64.zip
unzip -p /tmp/win32yank.zip win32yank.exe > /tmp/win32yank.exe
chmod +x /tmp/win32yank.exe
sudo mv /tmp/win32yank.exe /usr/local/bin
```
