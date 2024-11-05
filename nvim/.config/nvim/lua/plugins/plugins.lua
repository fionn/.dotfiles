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
    "hrsh7th/cmp-nvim-lua",
    "nvim-lua/plenary.nvim",
    "petertriho/cmp-git",
    {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
    "nvim-treesitter/nvim-treesitter-textobjects",
    "nvim-treesitter/nvim-treesitter-context",
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    "lewis6991/gitsigns.nvim",
    "FabijanZulj/blame.nvim",
    "linrongbin16/gitlinker.nvim",
    "folke/which-key.nvim",
    "Vimjas/vim-python-pep8-indent",
    "godlygeek/tabular",
    "hashivim/vim-terraform",
    "lukas-reineke/indent-blankline.nvim",
    "mbbill/undotree",
    "bullets-vim/bullets.vim",
    "fionn/nvim-redact-pass",
    "fionn/baseline"
}

require("plugins/treesitter")
require("plugins/completion")
require("plugins/lsp")

require("gitsigns").setup {
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

    on_attach = function(bufnr)
        local gitsigns = require("gitsigns")

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

        map({"o", "x"}, "ih", ":<C-U>Gitsigns select_hunk<CR>", {desc = "inner hunk"})
    end
}

require("blame").setup {
    date_format = "%Y-%m-%d"
}

require("gitlinker").setup {}

require("lsp_lines").setup {}

local hooks = require("ibl.hooks")
hooks.register(hooks.type.ACTIVE, function(bufnr)
    return vim.lsp.util.get_effective_tabstop(bufnr) < 4
end)

require("ibl").setup {
    indent = {
        char = "▏",
        smart_indent_cap = false
    },
    scope = {enabled = false}
}

local wk = require("which-key")
wk.setup {
    preset = "helix",
    delay = 600,
    expand = 1,
    icons = {rules = false}
}
wk.add({
    {"<leader>l", group = "Diagnostics"},
    {"<leader>s", group = "Swap"},
    {"<leader>t", group = "Tabularise"},
    {"<leader>b", group = "Git blame"}
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
