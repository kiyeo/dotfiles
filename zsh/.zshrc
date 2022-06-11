#!/usr/bin/env bash

export VISUAL=nvim
export EDITOR="$VISUAL"
COLORTERM=truecolor
# History in cache directory:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.cache/zsh/history

setopt No_Beep                     # Turn off all beeps
setopt prompt_subst                # Enable substitution in the prompt.
autoload colors && colors          # Enable colors and change prompt:
autoload -Uz compinit              # Basic auto/tab complete:
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)          # Include hidden files.

#cd - history
setopt AUTO_PUSHD                  # pushes the old directory onto the stack
setopt PUSHD_MINUS                 # exchange the meanings of '+' and '-'
setopt CDABLE_VARS                 # expand the expression (allows 'cd -2/tmp')
autoload -U compinit && compinit   # load + start completion
zstyle ':completion:*:directory-stack' list-colors '=(#b) #([0-9]#)*( *)==95=38;5;12'

# Find and set branch name var if in git repository.
function git_branch_name()
{
  local branch="$(git symbolic-ref HEAD 2> /dev/null | awk -F "/" '{print $NF}')"
  if [[ ! -z "$branch" ]]; then
    local current_branch="$(git branch --list master main | sed 's/.*\(master\|main\)/\1/')"
    if [[ "$(git name-rev @{u} 2> /dev/null)" ]]; then
      local head_commit_status="$(git rev-list --left-right --count  origin/"$current_branch"...origin/"$(git branch --show-current)" | awk '{print "%F{#e36154}↓"$1"%F{#00afff} %F{#88bf6a}↑"$2"%F{#00afff}"}')"
    else
      local head_commit_status="%F{#e36154}%F{#00afff}"
    fi
    local commit_status="$(git status -sb 2> /dev/null | grep -e "ahead" -e "behind")"
    local count_commit_status="$(echo "$commit_status" | grep -c ^)"
    if [[ "$count_commit_status" -gt 0 ]]; then
      local count_ahead="$(echo "$commit_status" | sed -n 's/.*ahead \([0-9]*\).*/\1/p')"
      count_ahead="$([[ "$count_ahead" -gt 0 ]] && echo " %F{#88bf6a}↑$count_ahead%F{#00afff}" || echo "")"
      local count_behind="$(echo "$commit_status" | sed -n 's/.*behind \([0-9]*\).*/\1/p')"
      count_behind="$([[ "$count_behind" -gt 0 ]] && echo " %F{#e36154}↓$count_behind%F{#00afff}" || echo "")"
      count_commit_status="$count_ahead$count_behind |"
    else
      count_commit_status=""
    fi

    local count_staged="$(git diff --name-only --staged 2> /dev/null | grep -c ^)"
    count_staged="$([[ "$count_staged" -gt 0 ]] && echo "%F{#88bf6a}+$count_staged%F{#00afff}" || echo "$count_staged")"

    local count_unstaged="$(git diff --name-only 2> /dev/null | grep -c ^)"
    if [[ "$count_unstaged" -gt 0 ]]; then
      local count_modified="$(git diff --name-status | grep -c "^M")"
      count_modified=$([[ $count_modified -gt 0 ]] && echo "%F{#ffaf00}~$count_modified%F{#00afff}" || echo "$count_modified")
      local count_deleted="$(git diff --name-status | grep -c "^D")"
      count_deleted=$([[ $count_deleted -gt 0 ]] && echo "%F{#e36154}-$count_deleted%F{#00afff}" || echo "$count_deleted")
      count_unstaged="$count_modified $count_deleted"
    fi

    local count_untracked="$(git ls-files --others --exclude-standard 2> /dev/null | grep -c ^)"
    count_untracked="$([[ "$count_untracked" -gt 0 ]] && echo "%F{#ffaf00}+$count_untracked%F{#00afff}" || echo "$count_untracked")"

    local count_stash="$(git stash list 2> /dev/null | grep -c ^)"
    count_stash="$([[ "$count_stash" -gt 0 ]] && echo " %F{#ffaf00}$count_stash%F{#00afff}" || echo "")"

    echo " ( $head_commit_status $branch$count_commit_status $count_staged $count_unstaged $count_untracked$count_stash)"
  fi
} 

prompt='%F{#88bf6a}%n %U%F{#00afff}%~%u$(git_branch_name)
> '

# vi mode
bindkey -v
export KEYTIMEOUT=1

autoload edit-command-line; zle -N edit-command-line
bindkey '^V' edit-command-line          # enter nvim buffer
bindkey -M vicmd "^V" edit-command-line # enter nvim buffer in normal mode

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect '^[[Z' reverse-menu-complete  # shift + tab
bindkey -v '^?' backward-delete-char                # Fix backspace bug when switching modes

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

source ~/.zsh/aliases.zsh

source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
typeset -gA ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#5f87ff'                  # sudo
ZSH_HIGHLIGHT_STYLES[command]='fg=#5f87ff'                     # ls
ZSH_HIGHLIGHT_STYLES[alias]='fg=#ffaf00'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#5f87ff'                     # fg
ZSH_HIGHLIGHT_STYLES[function]='fg=#5f87ff'
ZSH_HIGHLIGHT_STYLES[path]='fg=#00afff,underline'              # .zshrc, .config, dev, etc...
# ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=#00afff'        # /
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=#00afff'
# ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]='fg=#00afff'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#ffaf00'           # !!

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey '^f' autosuggest-accept
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#585858,underline'

eval "$(zoxide init zsh)"

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH=~/.local/bin:$PATH

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

