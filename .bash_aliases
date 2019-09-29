# bash aliases created by me
# run "source ~/.bashrc" to apply changes

alias ls="ls --color=auto"
if hash startx 2> /dev/null; then
    alias x="cd ~ && startx"
fi
alias grep="grep --color=auto"
alias diff="diff --color=auto"
alias dmesg="dmesg --color=auto"
alias tree="tree -C"
alias ip="ip -c"
alias gr="cd \$(git rev-parse --show-toplevel)"
alias view="vim -R"
alias vi=vim
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
