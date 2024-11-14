local dap = require("dap")
local widgets = require("dap.ui.widgets")

require("nvim-dap-virtual-text").setup {
    virt_text_pos = "eol",
    highlight_new_as_changed = true
}

vim.keymap.set("n", "<leader>dc", dap.continue, {desc = "Continue"})
vim.keymap.set("n", "<leader>dn", dap.step_over, {desc = "Step over"})
vim.keymap.set("n", "<leader>di", dap.step_into, {desc = "Step into"})
vim.keymap.set("n", "<leader>do", dap.step_out, {desc = "Step out"})
vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, {desc = "Set breakpoint"})
vim.keymap.set("n", "<leader>de", dap.repl.toggle, {desc = "Open REPL"})
vim.keymap.set({"n", "v"}, "<leader>dh", widgets.hover, {desc = "Hover"})
vim.keymap.set({"n", "v"}, "<leader>dp", widgets.preview, {desc = "Preview"})
vim.keymap.set("n", "<leader>df", widgets.sidebar(widgets.frames).open, {desc = "Show frames"})
vim.keymap.set("n", "<leader>ds", widgets.sidebar(widgets.scopes).open, {desc = "Show scopes"})

require("dap.ext.vscode").load_launchjs(nil, {})

dap.adapters.delve = function(callback, config)
    if config.mode == "remote" and config.request == "attach" then
        callback({
            type = "server",
            host = config.host or "127.0.0.1",
            port = config.port or "38697"
        })
    else
        callback({
            type = "server",
            port = "${port}",
            executable = {
                command = "dlv",
                args = { "dap", "-l", "127.0.0.1:${port}", "--log", "--log-output=dap" },
            }
        })
    end
end

dap.configurations.go = {
    {
        type = "delve",
        name = "Debug",
        request = "launch",
        program = "${file}"
    },
    {
        type = "delve",
        name = "Debug test",
        request = "launch",
        mode = "test",
        program = "${file}"
    },
    {
        type = "delve",
        name = "Debug test (go.mod)",
        request = "launch",
        mode = "test",
        program = "./${relativeFileDirname}"
    }
}
