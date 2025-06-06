require("nvim-treesitter.configs").setup {
    ensure_installed = {"c", "lua", "vim", "vimdoc", "query", "diff"},
    sync_install = false,
    auto_install = true,
    highlight = {
        enable = true,
        disable = {
            "gitcommit",
            "diff",
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
                ["if"] = {query = "@function.inner", desc = "inner @function"},
                ["af"] = {query = "@function.outer", desc = "@function"},
                ["ik"] = {query = "@block.inner", desc = "inner @block"},
                ["ak"] = {query = "@block.outer", desc = "@block"},
                ["ic"] = {query = "@class.inner", desc = "inner @class"},
                ["ac"] = {query = "@class.outer", desc = "@class"},
                ["as"] = {query = "@scope", query_group = "locals", desc = "@scope"}
            },
            selection_modes = {
                ["@parameter.outer"] = "v",
                ["@function.inner"] = "V",
                ["@function.outer"] = "V",
                ["@block.inner"] = "V",
                ["@block.outer"] = "V",
                ["@class.outer"] = "<C-v>"
            }
        },
        swap = {
            enable = true,
            swap_next = {
                ["<leader>sn"] = {
                    query = {"@parameter.inner", "@function.outer"},
                    desc = "Swap next @parameter or @function"
                }
            },
            swap_previous = {
                ["<leader>sp"] = {
                    query = {"@parameter.inner", "@function.outer"},
                    desc = "Swap previous @parameter or @function"
                }
            }
        },
        lsp_interop = {
            enable = true,
            peek_definition_code = {
                ["<leader>lpf"] = "@function.outer",
                ["<leader>lpc"] = "@class.outer"
            }
        }
    }
}

require("treesitter-context").setup {
  max_lines = 2,
  min_window_height = 3,
  multiline_threshold = 3,
  trim_scope = "inner",
  mode = "cursor",
  separator = "‾"
}
