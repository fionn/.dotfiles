vim.opt.secure = true
vim.opt.clipboard = "unnamedplus"
vim.opt.mouse = "a"

vim.opt.number = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = -1
vim.opt.expandtab = true
vim.opt.shiftround = true
vim.opt.breakindent = true
vim.opt.breakindentopt = {"list:-1"}
vim.opt.showmatch = false
vim.opt.matchtime = 1
vim.opt.smoothscroll = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.spelllang = "en_gb"
vim.opt.linebreak = true
vim.opt.redrawtime = 4000

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.undofile = true

vim.opt.title = true
vim.opt.titlestring = "%F %m%r"

vim.opt.list = true
vim.opt.listchars = {tab = "  ", trail = "·", extends = "▸", nbsp = "␣"}

vim.opt.signcolumn = "yes"

vim.opt.colorcolumn = {80}

vim.opt.cursorline = true
vim.opt.cursorlineopt = {"number"}

vim.opt.guicursor:append("i-ci-n:blinkon100")

vim.opt.shellcmdflag = "-ceuo pipefail"

vim.opt.wildmode = {"list:longest", "full"}

vim.opt.winblend = 8
vim.opt.pumblend = 8

vim.opt.pumheight = 40

vim.g.markdown_fenced_languages = {"python", "bash", "yaml", "lua"}

vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_special_syntax = true
vim.g.netrw_list_hide = {
    ".*\\.swp$", ".*\\.aux$", ".*\\.toc$", "__pycache__/$",
    ".mypy_cache/$", "venv/$", ".git/$"
}

-- h:ft-python-indent
vim.g.python_indent = {
    open_paren = 4,
    continue = 4,
    closed_paren_align_last_line = false
}

vim.api.nvim_create_augroup("options", {clear = true})

vim.api.nvim_create_autocmd("FileType", {
    group = "options",
    pattern = {"markdown", "gitcommit", "tex"},
    desc = "Spellcheck certain filetypes",
    callback = function()
        vim.opt_local.spell = true
    end
})

vim.api.nvim_create_autocmd("FileType", {
    group = "options",
    pattern = "gitcommit",
    desc = "Format options for Git commit messages",
    callback = function()
        vim.opt_local.formatoptions = {
            ["1"] = true, -- break before single words
            j = true, -- merge comments
            t = true, -- wrap
            n = true, -- indent lists
            a = true, -- auto-format
            q = true, -- format comments with gq
            w = true, -- use trailing whitespace as hint for paragraph end
            r = true, -- continue "comments" on new line
            c = true, -- wrap "comments"
        }
    end
})

vim.api.nvim_create_autocmd("BufRead", {
    group = "options",
    desc = "Set read-only buffers as not modifiable",
    callback = function()
        if vim.opt_local.readonly:get() then
            vim.opt_local.modifiable = false
        end
    end
})

vim.api.nvim_create_autocmd("BufRead", {
    group = "options",
    desc = "Only set colorcolumn on modifiable buffers",
    callback = function()
        ---@diagnostic disable-next-line: undefined-field
        if not vim.opt_local.modifiable:get() then
            vim.opt_local.colorcolumn = ""
        end
    end
})
