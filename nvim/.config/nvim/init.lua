require("options")
require("plugins")

local function reload()
    dofile(vim.env.MYVIMRC)
    vim.notify("Reloaded " .. vim.env.MYVIMRC)
end

local function close_floats()
    -- https://github.com/lettertwo/config/blob/main/nvim/lua/util/init.lua
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_is_valid(win)
           and vim.api.nvim_win_get_config(win).relative ~= "" then
            vim.api.nvim_win_close(win, false)
        end
    end
end

local function esc()
    close_floats()
    vim.cmd.nohlsearch()
    vim.diagnostic.config({virtual_lines = false})
end

local function toggle_relative_numbers()
    ---@diagnostic disable-next-line: undefined-field
    vim.opt_local.relativenumber = not vim.opt_local.relativenumber:get()
end

vim.keymap.set("", "<F1>", "<Nop>", {desc = "No-op"})
vim.keymap.set("n", "Q", "<Nop>", {desc = "No-op"})
vim.keymap.set("i", "<C-v>", "<Nop>", {desc = "No-op"})

vim.keymap.set("n", "<CR>", ":nohlsearch<CR><CR>", {silent = true})
vim.keymap.set("n", "<Esc>", esc, {desc = "Close floats and clear highlighting"})

vim.keymap.set("o", "j", "gj")
vim.keymap.set("o", "k", "gk")
vim.keymap.set("c", "<C-a>", "<Home>")
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

--vim.keymap.set("n", "<leader>u", "UndotreeToggle<CR>")
vim.keymap.set("n", "<leader>?", require("which-key").show, {desc = "Global keymappings"})
vim.keymap.set("n", "<leader>s", reload, {desc = "Reload config"})
vim.keymap.set("n", "<leader>nr", toggle_relative_numbers, {desc = "Toggle relative numbers"})
vim.keymap.set("n", "<leader>gl", require("lsp_lines").toggle, {desc = "Toggle LSP lines"})
vim.keymap.set("n", "<leader>gf", vim.diagnostic.open_float, {desc = "Open floating diagnostics"})

vim.api.nvim_create_user_command("W", "w", {})
vim.api.nvim_create_user_command("Q", "q", {})
vim.api.nvim_create_user_command("Wq", "wq", {})

vim.cmd.colorscheme("default_override")

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
})

-- https://neovim.io/doc/user/diagnostic.html
vim.diagnostic.config {
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "⨯",
            [vim.diagnostic.severity.WARN] = "⚠",
            [vim.diagnostic.severity.INFO] = "ⓘ",
            [vim.diagnostic.severity.HINT] = "☞"
        }
    },
    severity_sort = true,
    update_in_insert = true,
    virtual_lines = false,  -- for lsp_lines
    float = {
        border = "rounded",
        source = true
    }
}

vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("generic_fixers", {clear = true}),
    desc = "Remove trailing whitespace and blank lines",
    callback = function()
        -- Partially from neovim/runtime/lua/editorconfig.lua.
        -- TODO: translate to nvim_cmd.
        local view = vim.fn.winsaveview()
        vim.api.nvim_command("silent! undojoin")
        vim.api.nvim_command("silent keepjumps keeppatterns %s/\\s\\+$//e")
        vim.api.nvim_command("silent keepjumps keeppatterns %s/\\($\\n\\s*\\)\\+\\%$//e")
        vim.fn.winrestview(view)
    end
})

vim.api.nvim_create_autocmd("TermOpen", {
    group = vim.api.nvim_create_augroup("terminal", {clear = true}),
    desc = "Make the terminal more like a terminal",
    callback = function()
        vim.opt_local.number = false
        vim.cmd("startinsert")
    end
})

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("quick_close", {clear = true}),
    desc = "Close with q",
    pattern = {"help", "checkhealth", "qf"},
    callback = function(event)
        vim.keymap.set("n", "q", ":close<CR>", {buffer = event.buf, silent = true})
    end
})

vim.api.nvim_create_augroup("init", {clear = true})

vim.api.nvim_create_autocmd("TextYankPost", {
    group = "init",
    desc = "Highlight on yank",
    callback = function()
        vim.highlight.on_yank({higroup = "Visual"})
    end,
})

vim.api.nvim_create_autocmd("InsertEnter", {
    group = "init",
    desc = "Hide virtual text on insert",
    callback = function()
        vim.diagnostic.config({virtual_text = false})
        vim.diagnostic.config({virtual_lines = false})
    end
})

vim.api.nvim_create_autocmd({"BufWrite", "InsertLeave"}, {
    group = "init",
    desc = "Show virtual text in normal mode and on save",
    callback = function()
        vim.diagnostic.config({virtual_text = true})
    end
})

vim.api.nvim_create_autocmd("VimEnter", {
    group = "init",
    desc = "Clear jumplist",
    callback = function()
        vim.cmd("clearjumps")
    end
})
