#!/usr/bin/env bash

COLORTERM=truecolor

# Find and set branch name var if in git repository.
function git_branch_name()
{
  branch=$(git symbolic-ref HEAD 2> /dev/null | awk 'BEGIN{FS="/"} {print $NF}')
  if [[ $branch != "" ]]; then
    count_unstaged="$(git diff --name-only 2> /dev/null | grep -c "")"
    if [[ $count_unstaged -gt 0 ]]; then
      count_unstaged="%B%F{red}~$count_unstaged%f%b"
    fi
    count_staged="$(git diff --name-only --staged 2> /dev/null | grep -c "")"
    if [[ $count_staged -gt 0 ]]; then
      count_staged="%F{#87af5f}+$count_staged%f"
    fi
    count_untracked="$(git ls-files --others --exclude-standard 2> /dev/null | grep -c "")"
    if [[ $count_untracked -gt 0 ]]; then
      count_untracked="%B%F{red}~$count_untracked%f%b"
    fi
    count_unpushed="$(git cherry -v 2> /dev/null | grep -c "")"
    if [[ $count_unpushed -gt 0 ]]; then
      count_unpushed=" %F{#87af5f}+$count_unpushed%f |"
    else
      count_unpushed=""
    fi
    echo " ($branch$count_unpushed $count_staged $count_unstaged $count_untracked)%F{black}'$'\uE0B0''%f"
  fi
}


# Enable substitution in the prompt.
setopt prompt_subst

# Enable colors and change prompt:
autoload colors && colors
prompt='%F{#87af5f}%n%f %F{white}%K{#00afff}%~%k%f%F{#00afff}'$'\uE0B0''%f$(git_branch_name) '

# Turn off all beeps
unsetopt BEEP
# Turn off autocomplete beeps
# unsetopt LIST_BEEP

autoload -Uz compinit
compinit
# End of lines added by compinstall

# History in cache directory:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.cache/zsh/history

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
#_comp_options+=(globdots)		# Include hidden files.

# vi mode
bindkey -v
export KEYTIMEOUT=1


# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

export ZFUNCTIONS=${ZDOTDIR:-$HOME}/.zfunctions
[ -d $ZFUNCTIONS ] || mkdir -p $ZFUNCTIONS

# https://github.com/zsh-users/zsh-autosuggestions/issues/529
if autoload -U +X add-zle-hook-widget 2>/dev/null; then
    add-zle-hook-widget zle-line-pre-redraw _zsh_autosuggest_fetch
    add-zle-hook-widget zle-line-pre-redraw _zsh_autosuggest_highlight_apply
fi

source /etc/zsh_command_not_found

source ~/.zsh/aliases.zsh

source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#5f87ff' # sudo
ZSH_HIGHLIGHT_STYLES[command]='fg=#5f87ff' # ls
ZSH_HIGHLIGHT_STYLES[alias]='fg=#5f87ff'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#5f87ff' # fg
ZSH_HIGHLIGHT_STYLES[function]='fg=#5f87ff'
ZSH_HIGHLIGHT_STYLES[path]='fg=#00afff,underline' # .zshrc, .config, dev, etc...

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey '^f' autosuggest-accept
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#585858,underline'
