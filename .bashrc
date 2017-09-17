#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
#PS1='[\u@\h \W]\$ '

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

export EDITOR=vim
export VISUAL="$EDITOR"

# command not found
#[ -r /etc/profile.d/cnf.sh ] && . /etc/profile.d/cnf.sh
source /usr/share/doc/pkgfile/command-not-found.bash

[[ -f /usr/share/bash-completion/bash_completion ]] && \
    . /usr/share/bash-completion/bash_completion

# Git prompt
source /usr/share/git/completion/git-prompt.sh
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

export PATH=$HOME/bin:$PATH

