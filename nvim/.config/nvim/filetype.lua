vim.filetype.add {
    extension = {
        hujson = "jsonc"
    },
    filename = {
        ["osquery.conf"] = "jsonc",
    },
    pattern = {
        ["${HOME}/.kube/config"] = "yaml"
    }
}
