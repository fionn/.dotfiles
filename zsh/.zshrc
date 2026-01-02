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

# Disable XON/XOFF so we can send ^S for forward search
stty -ixon

export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

[[ -d "$XDG_STATE_HOME/zsh" ]] || mkdir -p "$XDG_STATE_HOME/zsh"
[[ -d "$XDG_CACHE_HOME/zsh" ]] || mkdir -p "$XDG_CACHE_HOME/zsh"

autoload -Uz compinit && compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
autoload -U bashcompinit && bashcompinit # required for terraform completion
autoload -Uz vcs_info
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook && add-zsh-hook chpwd chpwd_recent_dirs
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
autoload edit-command-line && zle -N edit-command-line

unalias run-help 2>/dev/null
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

function __tf_prompt {
    [[ -d .terraform/ && -r .terraform/environment ]] || return
    local -r workspace="$(< .terraform/environment)"
    echo " ($workspace)"
}

prompt="[%B%n@%m%b %1~\$(__tf_prompt)\$vcs_info_msg_0_]%# "

PROMPT_EOL_MARK="%F{240}⏎%f"

zstyle ":completion:*" insert-tab false
zstyle ":completion:*" cache-path "$XDG_CACHE_HOME/zsh/zcompcache"
zstyle ":completion:*:ssh:*:users" hidden true

zstyle ":chpwd:*" recent-dirs-file "$XDG_STATE_HOME/zsh/chpwd-recent-dirs"

zle_highlight+=(paste:bg=236)

tabs -4

zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey -e
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[1;2A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

bindkey "${terminfo[kpp]}" beginning-of-buffer-or-history
bindkey "${terminfo[knp]}" end-of-buffer-or-history

bindkey -M viins "^?" backward-delete-char

bindkey "^X^E" edit-command-line

export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
export EDITOR=nvim
export VISUAL=$EDITOR
export HISTSIZE=40000
export SAVEHIST=30000
export HISTORY_IGNORE="(exit|[bf]g|history *|jrnl *)"
export HISTFILE="$XDG_STATE_HOME/zsh/history"
export MANPAGER="nvim +Man!"
export GOPATH="$XDG_DATA_HOME/go"
export LANG=${LANG:-en_GB.UTF-8}
export ZLE_SPACE_SUFFIX_CHARS=$'&|'

[[ -d "$XDG_STATE_HOME/python" ]] || mkdir -p "$XDG_STATE_HOME/python"
export PYTHON_HISTORY="$XDG_STATE_HOME/python/history"

typeset -gU PATH path
path=("$path[@]" "$HOME/bin" "$HOME/.cargo/bin" "$GOPATH/bin")

if [[ -v HOMEBREW_PREFIX ]]; then
    export HOMEBREW_NO_ANALYTICS=1
    export HOMEBREW_NO_AUTO_UPDATE=1
    export HOMEBREW_NO_INSTALL_CLEANUP=1
    export HOMEBREW_NO_INSECURE_REDIRECT=1
    export HOMEBREW_NO_BOTTLE_SOURCE_FALLBACK=1
    export HOMEBREW_VERIFY_ATTESTATIONS=1

    path=("$HOMEBREW_PREFIX/opt/python3/libexec/bin" \
          "$HOMEBREW_PREFIX/opt/ruby/bin" "$HOMEBREW_PREFIX/opt/libpq/bin" "$path[@]")

    hash terraform 2>/dev/null && complete -o nospace -C "$(command -v terraform)" terraform
    hash tofu 2>/dev/null && complete -o nospace -C "$(command -v tofu)" tofu
fi

[[ -f $HOME/.bash_aliases ]] && . $HOME/.bash_aliases
[[ -f $HOME/.jobrc ]] && . $HOME/.jobrc

alias history="fc -li 0"

function search {
    grep -FRl "$@" .
}

if hash fzf 2>/dev/null; then
    FZF_CTRL_T_COMMAND="" FZF_ALT_C_COMMAND="" source <(fzf --zsh)
fi
