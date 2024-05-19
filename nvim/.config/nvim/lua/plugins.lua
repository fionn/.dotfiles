local function clone_paq()
    local path = vim.fn.stdpath("data") .. "/site/pack/paqs/start/paq-nvim"
    local is_installed = vim.fn.empty(vim.fn.glob(path)) == 0
    if not is_installed then
        vim.fn.system {
            "git", "clone", "--depth=1",
            "https://github.com/savq/paq-nvim.git", path
        }
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
    "savq/paq-nvim",
    -- List your packages
}

require "paq" {
    "savq/paq-nvim",
    "neovim/nvim-lspconfig",
    {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
    "nvim-treesitter/nvim-treesitter-textobjects",
    "lewis6991/gitsigns.nvim",
    {"fionn/grb256", opt = true}
}

require("nvim-treesitter.configs").setup {
    ensure_installed = {"c", "lua", "vim", "vimdoc", "query"},
    sync_install = false,
    auto_install = true,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            -- TODO: improve keybindings.
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm"
        }
    },
    textobjects = {
        select = {
            enable = true,
            lookahead = true,
            keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
                ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" }
            },
            selection_modes = {
                ["@parameter.outer"] = "v", -- charwise
                ["@function.outer"] = "V", -- linewise
                ["@class.outer"] = "<c-v>" -- blockwise
            },
            include_surrounding_whitespace = true
        }
    }
}

require("gitsigns").setup {
    signs = {
        add          = {text = "+"},
        change       = {text = "~"},
        delete       = {text = "_"},
        topdelete    = {text = "‾"},
        changedelete = {text = "~"},
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

local lspconfig = require("lspconfig")

lspconfig.clangd.setup {}
lspconfig.rust_analyzer.setup {}

lspconfig.lua_ls.setup {
    settings = {
        Lua = {
            completion = {
                keywordSnippet = "Disable"
            },
            diagnostics = {
                globals = {"vim"}
            }
        }
    }
}

--vim.cmd.packadd("grb256")
--vim.cmd.colorscheme("ff256")
