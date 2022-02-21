# dotfiles

```
sudo apt install zsh &&
  sudo apt install stow &&
  git clone https://github.com/Kiyeo/dotfiles.git &&
  cd dotfiles &&
  git submodule update --init --recursive &&
  stow * &&
  zsh
```
## submodule updates
```
git submodule update --recursive --remote
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
