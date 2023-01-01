# shellcheck shell=bash

alias grep="grep --color=auto"
alias dmesg="dmesg --color=auto"
alias tree="tree -C"
# shellcheck disable=SC2154
alias gr="_tl=\$(git rev-parse --show-toplevel) && cd \${_tl:?}"
alias view="vim -R"
alias vi=vim
alias activate="[[ -f venv/bin/activate ]] && source venv/bin/activate"
alias :q="echo \"Not in Vim\" && return 127"

if hash colordiff 2> /dev/null; then
    alias diff=colordiff
else
    alias diff="diff --color=auto"
fi

if [[ -f /usr/bin/ip ]]; then
    alias ip="ip -c"
fi

if ls --color -d . >/dev/null 2>&1; then
    alias ls="ls --color=auto --indicator-style=slash"
fi

if hash startx 2> /dev/null \
    && [[ ! $DISPLAY ]] && [[ ! $WAYLAND_DISPLAY ]] \
    && systemctl -q is-active graphical.target; then
    alias x='cd $HOME && startx'
fi

if [[ -n $WAYLAND_DISPLAY ]] && hash nvim 2> /dev/null; then
    alias vim=nvim
fi

if hash msfconsole 2> /dev/null; then
    alias msfconsole="msfconsole --quiet -x \"db_connect postgres@msf\""
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

if id bitcoin > /dev/null 2>&1; then
    alias bitcoin-cli="sudo -u bitcoin bitcoin-cli -datadir=/var/lib/bitcoind/"
fi
