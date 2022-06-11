# ⚪ dotfiles

![NeoVim](https://img.shields.io/badge/NeoVim-302d41?style=for-the-badge&logo=neovim)
![Lua](https://img.shields.io/badge/Lua-302d41?style=for-the-badge&logo=lua&logoColor=0062cc)
![Bash](https://img.shields.io/badge/Bash-302d41?style=for-the-badge&logo=gnu-bash)

```
git clone https://github.com/Kiyeo/dotfiles.git &&
  cd dotfiles &&
  ./install.sh &&
  zsh
```
### ⬆️ Submodule updates
```
git submodule update --recursive
git submodule foreach git pull origin master
```
### 🗑️ Uninstall dotfiles
```
cd dotfiles &&
  stow -D */
```
### 📋 Clipboard

If using WSL2, execute the following commands:

```
curl -sLo /tmp/win32yank.zip https://github.com/equalsraf/win32yank/releases/download/v0.0.4/win32yank-x64.zip
unzip -p /tmp/win32yank.zip win32yank.exe > /tmp/win32yank.exe
chmod +x /tmp/win32yank.exe
sudo mv /tmp/win32yank.exe /usr/local/bin
```

`Warning: Don’t blindly use my settings unless you know what that entails. Use at your own risk!`
