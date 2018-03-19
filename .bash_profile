#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

# eval $(ssh-agent)
# This variable is for ssh-agent.service
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
export GOPATH=$HOME/.go
