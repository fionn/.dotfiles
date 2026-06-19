vim.filetype.add {
    filename = {
        ["osquery.conf"] = "jsonc",
    },
    pattern = {
        ["${XDG_STATE_HOME}/zsh/history"] = "zsh",
        ["playbook%.ya?ml"] = "yaml.ansible",
        ["roles/[%a_]+/[%a_]+/[%a_]+%.ya?ml"] = "yaml.ansible",
        ["${XDG_DATA_HOME}/nvim/site/spell/[%a-]+%.utf%-8%.add"] = "wordlist"
    }
}
