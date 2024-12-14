vim.opt.secure = true
vim.opt.clipboard = "unnamedplus"
vim.opt.mouse = "a"
vim.opt.mousemodel = "extend"
vim.opt.termguicolors = true

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

vim.opt.foldenable = false
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldtext = ""
vim.opt.foldlevelstart = 99
vim.opt.foldnestmax = 4

vim.opt.fillchars = {foldopen = "", foldclose = "", foldsep = " ", fold = "‹"}

vim.opt.colorcolumn = {80}

vim.opt.cursorline = true
vim.opt.cursorlineopt = {"number"}

vim.opt.guicursor:append("i-ci-n:blinkon100")

vim.opt.shellcmdflag = "-ceuo pipefail"

vim.opt.wildmode = {"list:longest", "full"}

vim.opt.winblend = 8
vim.opt.pumblend = 8

vim.opt.pumheight = 40

if vim.opt.textwidth:get() == 0 then
    vim.opt_local.textwidth = 80
end
vim.opt.formatoptions:remove("t")
vim.opt.formatoptions:append({c = true})

vim.g.markdown_fenced_languages = {"python", "bash", "yaml", "json", "lua"}

vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = 24
vim.g.netrw_special_syntax = true
vim.g.netrw_list_hide = {
    ".*\\.swp$", ".*\\.aux$", ".*\\.toc$", "__pycache__/$",
    ".mypy_cache/$", "venv/$", ".git/$"
}

vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

-- h:ft-python-indent
vim.g.python_indent = {
    open_paren = 4,
    continue = 4,
    closed_paren_align_last_line = false
}

vim.api.nvim_create_augroup("options", {clear = true})

vim.api.nvim_create_autocmd("FileType", {
    group = "options",
    desc = "Spellcheck text-like filetypes",
    pattern = {"markdown", "gitcommit", "tex"},
    callback = function()
        vim.opt_local.spell = true
    end
})

vim.api.nvim_create_autocmd("FileType", {
    group = "options",
    desc = "Unset line wrapping in general",
    callback = function()
        vim.opt_local.formatoptions:remove("t")
    end
})

vim.api.nvim_create_autocmd("FileType", {
    group = "options",
    desc = "Don't wrap comments",
    pattern = "markdown",
    callback = function()
        vim.opt.formatoptions:remove("c")
    end
})

vim.api.nvim_create_autocmd("FileType", {
    group = "options",
    desc = "Format options for mail",
    pattern = "mail",
    callback = function()
        vim.opt_local.formatoptions:append({
            t = true,
            a = true,
            w = true
        })
    end
})

vim.api.nvim_create_autocmd("FileType", {
    group = "options",
    desc = "Set Go-specific options",
    pattern = "go",
    callback = function()
        vim.opt_local.colorcolumn = {80, 100}
        vim.opt_local.formatoptions:append({
            r = true,
            o = true,
            ["/"] = true
        }) -- Keep comment leader
    end
})

vim.api.nvim_create_autocmd("FileType", {
    group = "options",
    desc = "Format options for Git commit messages",
    pattern = "gitcommit",
    callback = function()
        vim.opt_local.formatoptions = {
            ["1"] = true, -- break before single character words
            t = true, -- wrap
            n = true, -- indent lists
            a = true, -- auto-format
            q = true, -- format comments with gq
            w = true, -- use trailing whitespace as hint for paragraph end
            r = true, -- continue "comments" on new line
        }
    end
})

vim.api.nvim_create_autocmd("FileType", {
    group = "options",
    desc = "Format JSON with jq",
    pattern = "json",
    callback = function()
        vim.opt_local.formatprg = "jq --indent 4"
    end
})

vim.api.nvim_create_autocmd("FileType", {
    group = "options",
    desc = "Remove status line for man pages",
    pattern = "man",
    callback = function()
        vim.opt_local.laststatus = 0
    end
})

vim.api.nvim_create_autocmd("FileType", {
    group = "options",
    desc = "Comment C and C++ files with //",
	pattern = {"c", "cpp"},
	callback = function()
		vim.opt_local.commentstring = "// %s"
	end,
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

vim.api.nvim_create_autocmd("BufRead", {
    group = "options",
    desc = "Use syntax completion when other sources are unavailable",
    callback = function()
        ---@diagnostic disable-next-line: undefined-field
        if vim.opt_local.omnifunc:get() == "" then
            vim.opt_local.omnifunc = "syntaxcomplete#Complete"
        end
    end
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = "options",
    desc = "Force LSP to override omnifunc",
    callback = function()
        ---@diagnostic disable-next-line: undefined-field
        vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
    end
})
