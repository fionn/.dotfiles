setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt CORRECT
setopt CORRECT_ALL
setopt PROMPT_SUBST
setopt COMPLETE_ALIASES
setopt NOAUTOMENU
setopt NOMENUCOMPLETE
setopt BASH_AUTO_LIST

autoload -Uz compinit && compinit
#autoload -U bashcompinit && bashcompinit
autoload -Uz vcs_info
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook && add-zsh-hook chpwd chpwd_recent_dirs

precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
zstyle ':vcs_info:*' enable git
zstyle ":vcs_info:git:*" check-for-changes true
zstyle ":vcs_info:git:*" unstagedstr "*"
zstyle ":vcs_info:git:*" stagedstr "+"
zstyle ":vcs_info:git:*" formats " (%b%u%c)"
zstyle ":vcs_info:git:*" actionformats " (%b %a|%m %u%c)"
zstyle ":vcs_info:git:*" patch-format " (%10>...>%p%<< %n/%a applied)"
PROMPT="[%n@%m %1~\$vcs_info_msg_0_]%# "

#zstyle ':completion:*:*:cdr:*:*' menu selection


export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
export EDITOR=vim
export VISUAL=$EDITOR
export HISTIGNORE="&:[ ]*:exit:bg:fg:history:jrnl *"
export MANPAGER="less -s -M +Gg"
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_ANALYTICS=1
export ZSH_AUTOSUGGEST_USE_ASYNC=1

tabs -4

[[ -f $HOME/.bash_aliases ]] && . $HOME/.bash_aliases
[[ -f /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && \
    . /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh

typeset -U PATH path
[[ -d /usr/local/opt/python/libexec/bin ]] && \
    path=("/usr/local/opt/python/libexec/bin" "$path[@]" "$HOME/bin")

function gr {
    git branch > /dev/null 2>&1 || return 1
    cd "$(git rev-parse --show-toplevel)" || return 1
}

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
#complete -o nospace -C /usr/local/bin/terraform terraform
