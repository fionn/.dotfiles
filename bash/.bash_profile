# shellcheck shell=bash
# shellcheck source=.bashrc
[[ -f ~/.bashrc ]] && . ~/.bashrc

export "$(/usr/lib/systemd/user-environment-generators/30-systemd-environment-d-generator 2>/dev/null)" 2>/dev/null
