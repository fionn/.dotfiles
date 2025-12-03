local function clone_paq()
    local path = vim.fn.stdpath("data") .. "/site/pack/paqs/start/paq-nvim"
    local is_installed = vim.fn.empty(vim.fn.glob(path)) == 0
    if not is_installed then
        vim.system({
            "git", "clone", "--depth=1",
            "https://github.com/savq/paq-nvim.git", path
        }):wait()
        return true
    end
end

local function bootstrap_paq(packages)
    local first_install = clone_paq()
    vim.cmd.packadd("paq-nvim")
    local paq = require("paq")
    if first_install then
        vim.notify("Installing plugins... If prompted, hit Enter to continue.")
    end
    if #paq.query("to_install") < 1 then return end
    paq(packages)
    paq.install()
end

bootstrap_paq {
    "savq/paq-nvim"
}

-- To fix folke/which-key, which force-updates the stable tag,
-- git -C ~/.local/share/nvim/site/pack/paqs/start/which-key.nvim fetch --tags --force.
require "paq" {
    "savq/paq-nvim",
    "neovim/nvim-lspconfig",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-omni",
    "hrsh7th/cmp-nvim-lua",
    "nvim-lua/plenary.nvim",
    "petertriho/cmp-git",
    {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
    "nvim-treesitter/nvim-treesitter-textobjects",
    "nvim-treesitter/nvim-treesitter-context",
    "lewis6991/gitsigns.nvim",
    "linrongbin16/gitlinker.nvim",
    "folke/which-key.nvim",
    "Vimjas/vim-python-pep8-indent",
    "godlygeek/tabular",
    "hashivim/vim-terraform",
    "lukas-reineke/indent-blankline.nvim",
    "rxbn/kube-schema.nvim",
    "mbbill/undotree",
    "bullets-vim/bullets.vim",
    "fionn/nvim-redact-pass",
    "fionn/baseline"
}

require("plugins/treesitter")
require("plugins/completion")
require("plugins/lsp")

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

        map({"o", "x"}, "ih", ":<C-U>Gitsigns select_hunk<CR>", {desc = "inner hunk"})

        vim.api.nvim_create_user_command("Blame", function(_) gitsigns.blame() end, {})
    end
}

require("gitlinker").setup {}

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
vim.g.terraform_fmt_on_save = 1

vim.g.undotree_SplitWidth = 30
vim.g.undotree_DiffCommand = "diff --minimal"
vim.g.undotree_ShortIndicators = 1
vim.g.undotree_HighlightChangedText = 0
vim.g.undotree_TreeNodeShape = "◇"
vim.g.undotree_TreeReturnShape = "╲"
vim.g.undotree_TreeVertShape = "│"
vim.g.undotree_TreeSplitShape ="╱"
