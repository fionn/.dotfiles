# shellcheck shell=bash

alias grep="grep --color=auto"
alias tree="tree -I .git --gitignore"
# shellcheck disable=SC2154
alias gr="_tl=\$(git rev-parse --show-toplevel) && cd \${_tl:?}"
alias view="vim -R"
alias vi=vim
alias activate="[[ -f venv/bin/activate ]] && source venv/bin/activate"
alias :q="echo \"Not in Vim\" >&2 && false"
alias ls="ls --color=auto -p"
alias decolour="perl -pe 's/\e\[?.*?[\@-~]//g'"

if hash colordiff 2> /dev/null; then
    alias diff=colordiff
else
    alias diff="diff --color=auto"
fi

if hash ip 2> /dev/null; then
    alias ip="ip -c"
fi

if hash startx 2> /dev/null \
    && [[ ! $DISPLAY ]] && [[ ! $WAYLAND_DISPLAY ]] \
    && systemctl -q is-active graphical.target; then
    alias x='cd $HOME && startx'
fi

if hash nvim 2> /dev/null; then
    alias vim=nvim
fi

if [[ -d /usr/share/nmap/scripts/ ]]; then
    alias nse="ls /usr/share/nmap/scripts/ | grep -i "
fi

if hash wl-copy 2> /dev/null; then
    alias pbcopy="wl-copy"
    alias pbpaste="wl-paste"
elif hash xclip 2> /dev/null; then
    alias pbcopy="xclip -selection clipboard"
    alias pbpaste="xclip -selection clipboard -o"
fi

if hash diskutil 2> /dev/null; then
    alias lsblk="diskutil list"
fi
