require("nvim-treesitter.configs").setup {
    ensure_installed = {"c", "lua", "vim", "vimdoc", "query", "diff"},
    sync_install = false,
    auto_install = true,
    highlight = {
        enable = true,
        disable = {
            "gitcommit",
            "markdown"
        },
        additional_vim_regex_highlighting = false
    },
    indent = {
        enable = true,
        disable = {
            "python"
        }
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
                ["ab"] = "@block.outer",
                ["ib"] = "@block.inner",
                ["ac"] = "@class.outer",
                ["ic"] = {query = "@class.inner", desc = "Select inner part of a class region"},
                ["as"] = {query = "@scope", query_group = "locals", desc = "Select language scope"}
            },
            selection_modes = {
                ["@parameter.outer"] = "v", -- charwise
                ["@function.outer"] = "V",  -- linewise
                ["@class.outer"] = "<C-v>"  -- blockwise
            },
            include_surrounding_whitespace = true
        }
    }
}
