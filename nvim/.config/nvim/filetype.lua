vim.filetype.add {
    filename = {
        ["osquery.conf"] = "jsonc",
    },
    pattern = {
        ["${HOME}/.kube/config"] = "yaml",
        ["${XDG_STATE_HOME}/zsh/history"] = "zsh",
        ["playbook.ya?ml"] = "yaml.ansible",
        ["roles/[%a_]+/[%a_]+/[%a_]+.ya?ml"] = "yaml.ansible",
        ["${HOME}/.ssh/[%w_]+.pub"] = "sshkey",
        ["${HOME}/.ssh/authorized_keys"] = "sshauthorizedkeys",
        ["${HOME}/.ssh/known_hosts"] = "sshknownhosts"
    }
}
