vim.filetype.add {
    extension = {
        hujson = "jsonc"
    },
    filename = {
        ["osquery.conf"] = "jsonc",
    },
    pattern = {
        ["${HOME}/.kube/config"] = "yaml",
        ["${XDG_STATE_HOME}/zsh/history"] = "zsh"
    }
}
