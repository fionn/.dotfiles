require("options")
require("plugins/plugins")

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
    vim.cmd.echo()
    vim.diagnostic.config({virtual_lines = false})
    vim.lsp.inlay_hint.enable(false)
end

local function toggle_relative_numbers()
    ---@diagnostic disable-next-line: undefined-field
    vim.opt_local.relativenumber = not vim.opt_local.relativenumber:get()
end


local function toggle_inlay_hint()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end

vim.keymap.set({"n", "v", "i"}, "<F1>", "<Nop>", {desc = "No-op", unique = true})
vim.keymap.set("n", "Q", "<Nop>", {desc = "No-op", unique = true})
vim.keymap.set("i", "<C-v>", "<Nop>", {desc = "No-op", unique = true})

vim.keymap.set("n", "<CR>", ":nohlsearch<CR><CR>", {silent = true})
vim.keymap.set("n", "<Esc>", esc, {desc = "Close and clear"})

vim.keymap.set("o", "j", "gj")
vim.keymap.set("o", "k", "gk")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", {desc = "Move selected lines up"})
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", {desc = "Move selected lines down"})

vim.keymap.set("c", "<C-a>", "<Home>")
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

vim.keymap.set("n", "gd", vim.lsp.buf.definition, {desc = "Go to definition, like <C-]>"})
vim.keymap.set("n", "gr", vim.lsp.buf.references, {desc = "List references"})

vim.keymap.set("n", "<leader>u", ":UndotreeToggle<CR>", {desc = "Toggle undotree"})
vim.keymap.set("n", "<leader>?", require("which-key").show, {desc = "Global keymappings"})
vim.keymap.set("n", "<leader>e", reload, {desc = "Reload config"})
vim.keymap.set("n", "<leader>nr", toggle_relative_numbers, {desc = "Toggle relative numbers"})
vim.keymap.set("n", "<leader>x", ":!chmod +x %<CR>", {desc = "Set executable bit", silent = true})
vim.keymap.set("x", "<leader>p", "\"_dP", {desc = "Paste without register"})

vim.keymap.set("n", "<leader>ll", require("lsp_lines").toggle, {desc = "Toggle LSP lines"})
vim.keymap.set("n", "<leader>lf", vim.diagnostic.open_float, {desc = "Open floating diagnostics, like <C-w>d"})
vim.keymap.set("n", "<leader>lh", toggle_inlay_hint, {desc = "Toggle inlay hints"})
vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, {desc = "Rename word under cursor"})
vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, {desc = "Select code action under cursor"})

vim.keymap.set("n", "<leader>t=", ":Tabularize /=<CR>", {desc = "Align by ="})
vim.keymap.set("n", "<leader>t:", ":Tabularize /:\\zs<CR>", {desc = "Align by :"})

vim.keymap.set("n", "<leader>bt", ":BlameToggle<CR>", {desc = "Toggle blame window"})
vim.keymap.set("n", "<leader>bl", require("gitsigns").toggle_current_line_blame, {desc = "Toggle blame lines"})
vim.keymap.set("n", "<leader>bf", require("gitsigns").blame_line, {desc = "Blame in floating window"})

vim.api.nvim_create_user_command("W", "w", {})
vim.api.nvim_create_user_command("Q", "q", {})
vim.api.nvim_create_user_command("Wq", "wq", {})

vim.cmd.colorscheme("default_override")

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded"
})

-- https://neovim.io/doc/user/diagnostic.html
vim.diagnostic.config {
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "⨯",
            [vim.diagnostic.severity.WARN] = "⚠",
            [vim.diagnostic.severity.INFO] = "ℹ",
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
        if vim.bo.filetype ~= "diff" and vim.bo.filetype ~= "mail" then
            -- Partially from neovim/runtime/lua/editorconfig.lua.
            -- TODO: translate to nvim_cmd.
            local view = vim.fn.winsaveview()
            vim.api.nvim_command("silent! undojoin")
            vim.api.nvim_command("silent keepjumps keeppatterns %s/\\s\\+$//e")
            vim.api.nvim_command("silent keepjumps keeppatterns %s/\\($\\n\\s*\\)\\+\\%$//e")
            vim.fn.winrestview(view)
        end
    end
})

vim.api.nvim_create_autocmd("FileType", {
    desc = "Meta-level format on save",
    pattern = "go",
    group = vim.api.nvim_create_augroup("format_on_save", {clear = true}),
    callback = function()
        vim.api.nvim_create_autocmd("BufWritePre", {
            desc = "Format on save",
            group = "format_on_save",
            callback = function()
                vim.lsp.buf.format({async = false})
            end
        })
    end,
})

vim.api.nvim_create_autocmd("TermOpen", {
    group = vim.api.nvim_create_augroup("terminal", {clear = true}),
    desc = "Make the terminal more like a terminal",
    callback = function()
        vim.opt_local.number = false
        vim.cmd.startinsert()
    end
})

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("quick_close", {clear = true}),
    desc = "Close with q",
    pattern = {"help", "checkhealth", "qf", "netrw"},
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
    end
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
        vim.cmd.clearjumps()
    end
})

vim.cmd.inoreabbrev({"seperate", "separate"})
