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
    {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
    "nvim-treesitter/nvim-treesitter-textobjects",
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    "lewis6991/gitsigns.nvim",
    "FabijanZulj/blame.nvim",
    "folke/which-key.nvim",
    "godlygeek/tabular",
    "hashivim/vim-terraform",
    "fionn/baseline",
    {"fionn/grb256", opt = true}
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
    }
}

require("blame").setup {
    date_format = "%Y-%m-%d"
}

require("lsp_lines").setup {}

local wk = require("which-key")
wk.setup {
    preset = "helix",
    delay = 600,
    expand = 1,
    icons = {rules = false}
}
wk.add({
    {"<leader>l", group = "Diagnostics"}
})

require("baseline").setup {}

vim.g.terraform_align = 1
vim.g.hcl_align = 1
vim.g.terraform_fmt_on_save = 1
