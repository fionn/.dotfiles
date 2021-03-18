# ~/.bashrc
# shellcheck disable=SC2034

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# shellcheck source=.bash_aliases
[[ -f ~/.bash_aliases ]] && . ~/.bash_aliases

#[ -r /etc/profile.d/cnf.sh ] && . /etc/profile.d/cnf.sh
# shellcheck source=/dev/null
[[ -f /usr/share/doc/pkgfile/command-not-found.bash ]] && \
    . /usr/share/doc/pkgfile/command-not-found.bash

# shellcheck source=/dev/null
[[ -f /usr/share/bash-completion/bash_completion ]] && \
    . /usr/share/bash-completion/bash_completion

hash terraform 2> /dev/null && complete -o nospace -C "$(command -v terraform)" terraform

PS1='[\u@\h \W]\$ '
if [[ -f /usr/share/git/completion/git-prompt.sh ]]; then
    # shellcheck source=/dev/null
    source /usr/share/git/completion/git-prompt.sh
    GIT_PS1_SHOWDIRTYSTATE=1
    GIT_PS1_SHOWSTASHSTATE=1
    GIT_PS1_SHOWUPSTREAM="auto"
    PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '
fi

export EDITOR=vim
export VISUAL="$EDITOR"
export SYSTEMD_EDITOR="$EDITOR"

export HISTSIZE=10000
export HISTFILESIZE=10000
export HISTCONTROL=ignoreboth:erasedups
export HISTIGNORE="&:[ ]*:exit:bg:fg:history:jrnl *"
export HISTTIMEFORMAT="%F %T "

export PATH=$PATH:$HOME/bin

shopt -s histappend
shopt -s cmdhist
shopt -s dirspell
shopt -s cdspell
shopt -s globstar

tabs -4
