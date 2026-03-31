vim.api.nvim_create_autocmd('PackChanged', {
    -- Adapted from https://echasnovski.com/blog/2026-03-13-a-guide-to-vim-pack#hooks.
    group = vim.api.nvim_create_augroup("build_packages", {clear = true}),
    desc = "Build packages",
    callback = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        if name == "nvim-treesitter" and kind == "update" then
            if not ev.data.active then
                vim.cmd.packadd("nvim-treesitter")
            end
            vim.cmd.TSUpdate()
        end
    end
})

vim.pack.add({
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/hrsh7th/nvim-cmp",
    "https://github.com/hrsh7th/cmp-nvim-lsp",
    "https://github.com/hrsh7th/cmp-nvim-lsp-signature-help",
    "https://github.com/hrsh7th/cmp-buffer",
    "https://github.com/hrsh7th/cmp-omni",
    "https://github.com/hrsh7th/cmp-nvim-lua",
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/petertriho/cmp-git",
    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
    "https://github.com/nvim-treesitter/nvim-treesitter-context",
    "https://github.com/lewis6991/gitsigns.nvim",
    "https://github.com/linrongbin16/gitlinker.nvim",
    "https://github.com/fionn/git-conflict.nvim",
    "https://github.com/folke/which-key.nvim",
    "https://github.com/Vimjas/vim-python-pep8-indent",
    "https://github.com/godlygeek/tabular",
    "https://github.com/hashivim/vim-terraform",
    "https://github.com/lukas-reineke/indent-blankline.nvim",
    "https://github.com/rxbn/kube-schema.nvim",
    "https://github.com/towolf/vim-helm",
    "https://github.com/bullets-vim/bullets.vim",
    "https://github.com/fionn/nvim-redact-pass",
    "https://github.com/fionn/nvim-hujson",
    "https://github.com/fionn/nvim-cycle-boolean",
    "https://github.com/fionn/baseline"
})

require("plugins/treesitter")
require("plugins/completion")
require("plugins/lsp")

vim.cmd.packadd("nvim.undotree")

local gitsigns = require("gitsigns")
gitsigns.setup {
    signs = {
        add          = {text = "+"},
        change       = {text = "~"},
        delete       = {text = "_"},
        topdelete    = {text = "‾"},
        changedelete = {text = "~"},
        untracked    = {text = "┆"}
    },
    signs_staged = {
        add          = {text = "┃"},
        change       = {text = "┃"},
        delete       = {text = "."},
        topdelete    = {text = "˙"},
        changedelete = {text = "."},
        untracked    = {text = "┆"}
    },
    current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "right_align",
        delay = 0
    },
    current_line_blame_formatter = "<abbrev_sha> <author> <author_time> <summary>",
    diff_opts = {
        algorithm = "histogram"
    },
    gh = true,

    on_attach = function(bufnr)
        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            opts.unique = true
            vim.keymap.set(mode, l, r, opts)
        end

        map("n", "]c", function()
            if vim.wo.diff then
                vim.cmd.normal({"]c", bang = true})
            else
                gitsigns.nav_hunk("next")
            end
        end, {desc = "Next hunk"})

        map("n", "[c", function()
            if vim.wo.diff then
                vim.cmd.normal({"[c", bang = true})
            else
                gitsigns.nav_hunk("prev")
            end
        end, {desc = "Previous hunk"})

        map("n", "<leader>hs", gitsigns.stage_hunk, {desc = "Stage"})
        map("n", "<leader>hr", gitsigns.reset_hunk, {desc = "Reset"})
        map("n", "<leader>hu", gitsigns.undo_stage_hunk, {desc = "Unstage"})
        map("n", "<leader>hp", gitsigns.preview_hunk, {desc = "Preview"})
        map("n", "<leader>hd", gitsigns.diffthis, {desc = "Diff"})

        map("n", "<leader>bl", gitsigns.toggle_current_line_blame, {desc = "Toggle blame lines"})
        map("n", "<leader>bf", gitsigns.blame_line, {desc = "Blame in floating window"})

        map({"o", "x"}, "ih", function() gitsigns.select_hunk({greedy = false}) end, {desc = "inner hunk"})
        map({"o", "x"}, "ah", gitsigns.select_hunk, {desc = "outer hunk"})

        vim.api.nvim_create_user_command("Blame", function(_) gitsigns.blame() end, {})
    end
}

require("gitlinker").setup {}

require("git-conflict").setup {
    disable_diagnostics = true
}

require("kube-schema").setup {
    notifications = false
}

local ibl = require("ibl")
ibl.setup {
    enabled = false,
    indent = {
        char = "▏",
        smart_indent_cap = false
    },
    scope = {
        enabled = true,
        show_start = false,
        show_end = false,
        char = "▎"
    }
}

vim.api.nvim_create_autocmd("FileType", {
    desc = "Enable indent guides",
    pattern = "yaml",
    group = vim.api.nvim_create_augroup("ibl", {clear = true}),
    callback = function()
        ibl.setup_buffer(0, {enabled = true})
    end
})

local wk = require("which-key")
wk.setup {
    preset = "helix",
    delay = function(ctx)
        return ctx.plugin and 0 or 600
    end,
    expand = 1,
    icons = {rules = false}
}
wk.add({
    {"[", group = "previous"},
    {"]", group = "next"},
    {"gr", group = "lsp"},
    {"<leader>", group = "leader", mode = {"n", "v"}},
    {"<leader>l", group = "diagnostics"},
    {"<leader>lp", group = "peek", mode = {"n", "v"}},
    {"<leader>v", group = "incremental selection", mode = "v"},
    {"<leader>s", group = "swap"},
    {"<leader>t", group = "tabularise"},
    {"<leader>b", group = "git blame"},
    {"<leader>h", group = "git hunk"}
})

vim.g.terraform_align = 1
vim.g.hcl_align = 1
