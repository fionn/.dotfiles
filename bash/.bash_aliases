# shellcheck shell=bash

alias grep="grep --color=auto"
alias tree="tree -I .git --gitignore"
# shellcheck disable=SC2154
alias gr="_tl=\$(git rev-parse --show-toplevel) && cd \${_tl:?}"
alias view="vim -R"
alias activate="[[ -f venv/bin/activate ]] && source venv/bin/activate"
alias :q="echo \"Not in Vim\" >&2 && false"
alias ls="ls --color=auto -p"
alias decolour="perl -pe 's/\e\[?.*?[\@-~]//g'"
alias diff="diff --color=auto -u"

if hash nvim 2> /dev/null; then
    alias vim=nvim
fi

if hash rdap 2> /dev/null; then
    alias whois="rdap --log-level warn -O gtld-whois"
fi

# shellcheck disable=SC2249
case "$OSTYPE" in
    linux*)
        if [[ -z $DISPLAY ]] && [[ -z $WAYLAND_DISPLAY ]] \
           && hash startx 2> /dev/null \
           && systemctl -q is-active graphical.target; then
            alias x='cd $HOME && startx'
        fi

        if hash wl-copy 2> /dev/null; then
            alias pbcopy="wl-copy"
            alias pbpaste="wl-paste"
        elif hash xclip 2> /dev/null; then
            alias pbcopy="xclip -selection clipboard"
            alias pbpaste="xclip -selection clipboard -o"
        fi
        ;;
    darwin*)
        alias lsblk="diskutil list"

        if hash ip 2> /dev/null; then
            alias ip="ip -c"
        fi
        ;;
esac
