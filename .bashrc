#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#PS1='[\u@\h \W ]\$ '

alias ls='ls --color=auto'
# shellcheck source=/home/fionn/.bash_aliases
[[ -f ~/.bash_aliases ]] && . ~/.bash_aliases

export EDITOR=vim
export VISUAL="$EDITOR"

#[ -r /etc/profile.d/cnf.sh ] && . /etc/profile.d/cnf.sh
[[ -f /usr/share/doc/pkgfile/command-not-found.bash ]] && \
    . /usr/share/doc/pkgfile/command-not-found.bash

# shellcheck disable=SC1094
[[ -f /usr/share/bash-completion/bash_completion ]] && \
    . /usr/share/bash-completion/bash_completion

[[ -f /usr/share/git/completion/git-prompt.sh ]] && \
    . /usr/share/git/completion/git-prompt.sh

GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWUPSTREAM="auto"
GIT_PS1_SHOWCOLORHINTS="true"
PS1='[\u@\h \W $(__git_ps1 "(%s)")]\$ '

export HISTSIZE=10000
export HISTFILESIZE=10000
export HISTCONTROL=ignoredups:erasedups
export HISTIGNORE="&:[ ]*:exit:bg:fg:history:jrnl *"
export HISTTIMEFORMAT="%F %T "

shopt -s histappend
shopt -s cmdhist
shopt -s dirspell
shopt -s cdspell

export PATH=$HOME/bin:$HOME/.local/bin:$PATH:$HOME/node_modules/.bin

