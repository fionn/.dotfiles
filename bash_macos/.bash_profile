# .bash_profile for macos machines in work.
# shellcheck disable=SC2034

export BASH_COMPLETION_COMPAT_DIR=/usr/local/etc/bash_completion.d
# shellcheck source=/dev/null
[ -r /usr/local/etc/profile.d/bash_completion.sh ] && . /usr/local/etc/profile.d/bash_completion.sh
# shellcheck source=/dev/null
[ -f /usr/local/etc/bash_completion.d/brew-services ] && . /usr/local/etc/bash_completion.d/brew-services

# No en_HK locale :(
base_locale=en_GB.UTF-8
export LC_NUMERIC=$base_locale
export LC_TIME=$base_locale
export LC_COLLATE=$base_locale
export LC_MONETARY=$base_locale
export LC_MESSAGES=$base_locale

export PS1='[\[\e[1m\]\u@\h\[\e[0m\] \W]\$ '
if [ -f /usr/local/etc/bash_completion.d/git-prompt.sh ]; then
    # shellcheck source=/dev/null
    source /usr/local/etc/bash_completion.d/git-prompt.sh
    GIT_PS1_SHOWDIRTYSTATE=1
    GIT_PS1_SHOWSTASHSTATE=1
    GIT_PS1_SHOWUNTRACKEDFILES=1
    GIT_PS1_SHOWUPSTREAM=auto
    GIT_PS1_SHOWCOLORHINTS=1
    PS1='[\[\e[1m\]\u@\h\[\e[0m\] \W$(__git_ps1 " (%s)")]\$ '
fi

# General unix options
export EDITOR=vim
export VISUAL=$EDITOR
export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
export HISTSIZE=100000
export HISTFILESIZE=100000
export HISTCONTROL=ignoreboth
export HISTIGNORE="&:[ ]*:exit:bg:fg:history:jrnl *"
export HISTTIMEFORMAT="%F %T "
export MANPAGER="less -s -M +Gg"

function man_colour {
    # https://unix.stackexchange.com/a/147
    LESS_TERMCAP_mb=$(tput bold; tput setaf 2) \
    LESS_TERMCAP_md=$(tput bold; tput setaf 6) \
    LESS_TERMCAP_me=$(tput sgr0) \
    LESS_TERMCAP_so=$(tput bold; tput setaf 3; tput setab 4) \
    LESS_TERMCAP_se=$(tput rmso; tput sgr0) \
    LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 7) \
    LESS_TERMCAP_ue=$(tput rmul; tput sgr0) \
    LESS_TERMCAP_mr=$(tput rev) \
    LESS_TERMCAP_mh=$(tput dim) \
    command man "$@"
}

# shellcheck source=/dev/null
[[ -f "$HOME/.bash_aliases" ]] && . "$HOME/.bash_aliases"
# shellcheck source=/dev/null
[[ -f "$HOME/.shell_secrets" ]] && . "$HOME/.shell_secrets"

# Package options
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_BOTTLE_SOURCE_FALLBACK=1
export HOMEBREW_NO_INSTALL_CLEANUP=1

export PATH=/usr/local/opt/python@3/libexec/bin:$PATH:/usr/local/sbin:$HOME/bin
export GOPATH=$HOME/.local/share/go

shopt -s nocaseglob
shopt -s histappend
shopt -s cmdhist
shopt -s dirspell
shopt -s cdspell

tabs -4

function search {
    grep -FRl "$1" .
}

hash terraform 2> /dev/null && complete -o nospace -C "$(command -v terraform)" terraform

function gpg_agent_ssh_auth_sock {
    unset SSH_AGENT_PID
    if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
        SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
        export SSH_AUTH_SOCK
    fi
    gpgconf --launch gpg-agent
}

#gpg_agent_ssh_auth_sock
