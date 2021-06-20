setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt PROMPT_SUBST
setopt COMPLETE_ALIASES
setopt NOAUTOMENU
setopt NOMENUCOMPLETE
setopt BASH_AUTO_LIST

autoload -Uz compinit && compinit
autoload -U bashcompinit && bashcompinit # required for terraform completion
autoload -Uz vcs_info
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook && add-zsh-hook chpwd chpwd_recent_dirs

precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
zstyle ":vcs_info:*" enable git
zstyle ":vcs_info:git:*" check-for-changes true
zstyle ":vcs_info:git:*" unstagedstr "*"
zstyle ":vcs_info:git:*" stagedstr "+"
zstyle ":vcs_info:git:*" formats " (%b%u%c)"
zstyle ":vcs_info:git:*" actionformats " (%b %a|%m %u%c)"
zstyle ":vcs_info:git:*" patch-format " (%10>...>%p%<< %n/%a applied)"
prompt="[%B%n@%m%b %1~\$vcs_info_msg_0_]%# "

PROMPT_EOL_MARK="%B%S%F{240}%#%f%s%b"

#zstyle ':completion:*:*:cdr:*:*' menu selection
style ":completion:*" insert-tab false
zstyle ":completion:*:ssh:*:users" hidden true

export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
export EDITOR=vim
export VISUAL=$EDITOR
export HISTIGNORE="&:[ ]*:exit:bg:fg:history:jrnl *"
export MANPAGER="less -s -M +Gg"
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_INSTALL_CLEANUP=1
export GOPATH=$HOME/.go

tabs -4

typeset -gU PATH path
[[ -d /usr/local/opt/python3/libexec/bin ]] && \
    path=(/usr/local/opt/python3/libexec/bin "$path[@]")
path+=(/usr/local/sbin "$HOME/bin" "$GOPATH/bin")

[[ -f $HOME/.bash_aliases ]] && . $HOME/.bash_aliases
[[ -f $HOME/.shell_secrets ]] && . $HOME/.shell_secrets
[[ -f $HOME/.jobrc ]] && . $HOME/.jobrc

alias history="fc -l 0"

function search {
    grep -FRl "$1" .
}

function gpg_agent {
    unset SSH_AGENT_PID
    if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
        SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
        export SSH_AUTH_SOCK
    fi
    gpgconf --launch gpg-agent
}

#gpg_agent

hash terraform 2> /dev/null && complete -o nospace -C "$(command -v terraform)" terraform
