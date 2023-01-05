# shellcheck shell=bash
# shellcheck source=.bashrc
[[ -f ~/.bashrc ]] && . ~/.bashrc

#shellcheck disable=SC2046  # we need word-splitting to parse the list of variables
export $(/usr/lib/systemd/user-environment-generators/30-systemd-environment-d-generator 2>/dev/null) &>/dev/null
