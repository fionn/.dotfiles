# bash aliases created by me
# run "source ~/.bashrc" to apply changes

alias ls="ls --color=auto"
alias grep="grep --color=auto"
alias diff="diff --color=auto"
alias dmesg="dmesg --color=auto"
alias tree="tree -C"
alias ip="ip -c"
alias gr="cd \$(git rev-parse --show-toplevel)"
alias view="vim -R"
alias vi=vim

if hash startx 2> /dev/null; then
    alias x="cd ~ && startx"
fi

if hash msfconsole 2> /dev/null; then
    alias msfconsole="msfconsole --quiet -x \"db_connect postgres@msf\""
fi

if [[ -d /usr/share/nmap/scripts/ ]]; then
    alias nse="ls /usr/share/nmap/scripts/ | grep -i "
fi

if hash xclip 2> /dev/null; then
    alias pbcopy="xclip -selection clipboard"
    alias pbpaste="xclip -selection clipboard -o"
fi

if [[ -f /usr/lib/opensc-pkcs11.so ]]; then
    alias ssh-init-opensc-agent="ssh-add -s /usr/lib/opensc-pkcs11.so"
elif [[ -f /usr/local/lib/opensc-pkcs11.so ]]; then
    alias ssh-init-opensc-agent="ssh-add -s /usr/local/lib/opensc-pkcs11.so"
fi

if hash diskutil 2> /dev/null; then
    alias lsblk="diskutil list"
fi
