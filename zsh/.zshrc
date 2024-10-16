setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_NO_STORE
setopt EXTENDED_HISTORY
setopt PROMPT_SUBST
setopt COMPLETE_ALIASES
setopt NOAUTOMENU
setopt NOMENUCOMPLETE
setopt BASH_AUTO_LIST
setopt INTERACTIVE_COMMENTS
setopt PIPE_FAIL

if type brew &>/dev/null; then
    fpath=("$HOMEBREW_PREFIX/share/zsh/site-functions" $fpath)
fi

autoload -Uz compinit && compinit
autoload -U bashcompinit && bashcompinit # required for terraform completion
autoload -Uz vcs_info
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook && add-zsh-hook chpwd chpwd_recent_dirs
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search

unalias run-help
autoload run-help
alias help=run-help

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

PROMPT_EOL_MARK="%F{240}⏎%f"

zstyle ":completion:*" insert-tab false
zstyle ":completion:*:ssh:*:users" hidden true

zle_highlight+=(paste:bg=236)

tabs -4

zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
export EDITOR=nvim
export VISUAL=$EDITOR
export HISTSIZE=40000
export SAVEHIST=30000
export HISTORY_IGNORE="(exit|[bf]g|history *|jrnl *)"
export HISTFILE=${HISTFILE:-$HOME/.zsh_history}
export MANPAGER="less -s -M +Gg"
export GOPATH=$HOME/.local/share/go
export LANG=${LANG:-en_GB.UTF-8}
export ZLE_SPACE_SUFFIX_CHARS=$'&|'

export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_INSTALL_CLEANUP=1
export HOMEBREW_NO_INSECURE_REDIRECT=1
export HOMEBREW_NO_BOTTLE_SOURCE_FALLBACK=1

typeset -gU PATH path
path=("$HOMEBREW_PREFIX/opt/python3/libexec/bin" "$path[@]" "$HOME/bin" "$GOPATH/bin" "$HOME/.cargo/bin")

[[ -f $HOME/.bash_aliases ]] && . $HOME/.bash_aliases
[[ -f $HOME/.jobrc ]] && . $HOME/.jobrc

alias history="fc -li 0"

function search {
    grep -FRl "$@" .
}

hash terraform 2> /dev/null && complete -o nospace -C "$(command -v terraform)" terraform
