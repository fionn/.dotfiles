# bash aliases created by me
# run "source ~/.bashrc" to apply changes

alias ls='ls --color=auto'
alias x='cd ~ && startx'
alias ssh='ssh-add -l || ssh-add -t 7200 && ssh' # Seems necessary :(
#alias wolfram='/home/fionn/builds/mathematica/pkg/mathematica/opt/Mathematica/Executables/wolfram'
#alias octave='octave-cli --silent' # or 'octave --no-gui-libs'
alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias dmesg='dmesg --color=auto'
alias tree='tree -C'
alias ip='ip -c'
