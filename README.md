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
