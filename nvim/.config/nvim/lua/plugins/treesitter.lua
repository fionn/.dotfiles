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
            init_selection = "<leader>vn",
            node_incremental = "<leader>vi",
            scope_incremental = "<leader>vs",
            node_decremental = "<leader>vd"
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
        },
        swap = {
            enable = true,
            swap_next = {
                ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
                ["<leader>A"] = "@parameter.inner",
            }
        }
    }
}

require("treesitter-context").setup {
  max_lines = 2,
  min_window_height = 3,
  multiline_threshold = 3,
  trim_scope = "inner",
  mode = "cursor",  -- "cursor" or "topline"
  separator = "‾"
}
