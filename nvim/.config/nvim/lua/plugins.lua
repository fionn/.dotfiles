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

local function has_words_before()
    -- From https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings.
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:
        sub(col, col):match("%s") == nil
end

bootstrap_paq {
    "savq/paq-nvim",
    -- List your packages
}

require "paq" {
    "savq/paq-nvim",
    "neovim/nvim-lspconfig",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
    "nvim-treesitter/nvim-treesitter-textobjects",
    "lewis6991/gitsigns.nvim",
    "godlygeek/tabular",
    "hashivim/vim-terraform",
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
                ["ic"] = {query = "@class.inner", desc = "Select inner part of a class region"},
                ["as"] = {query = "@scope", query_group = "locals", desc = "Select language scope"}
            },
            selection_modes = {
                ["@parameter.outer"] = "v", -- charwise
                ["@function.outer"] = "V", -- linewise
                ["@class.outer"] = "<C-v>" -- blockwise
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

local cmp = require("cmp")
local cmp_lsp = require("cmp_nvim_lsp")

cmp.setup {
    -- TODO: https://github.com/hrsh7th/nvim-cmp/wiki/Advanced-techniques#disabling-completion-in-certain-contexts-such-as-comments
    preselect = cmp.PreselectMode.None,

    completion = {
        autocomplete = false
    },

    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered()
    },

    experimental = {
        ghost_text = true
    },

    mapping = cmp.mapping.preset.insert {
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<Esc>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                if #cmp.get_entries() == 1 then
                    cmp.confirm({ select = true })
                elseif cmp.get_selected_entry() then
                    cmp.select_next_item()
                else
                    --cmp.select_next_item()
                    cmp.complete_common_string()
                end
            elseif has_words_before() then
                cmp.complete()
                if #cmp.get_entries() == 1 then
                    cmp.confirm({ select = true })
                end
            else
                fallback()
            end
        end, {"i", "s"}),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            else
                fallback()
            end
        end, {"i", "s"})
    },

    matching = {
        disallow_fuzzy_matching = true
    },

    sources = cmp.config.sources({
        {name = "nvim_lsp"},
        {name = "buffer"}
    })
}

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
local lspconfig = require("lspconfig")

lspconfig.clangd.setup {
    capabilities = cmp_lsp.default_capabilities()
}

lspconfig.rust_analyzer.setup {
    capabilities = cmp_lsp.default_capabilities()
}

lspconfig.pylsp.setup {
    -- TODO: configure this.
    -- https://github.com/python-lsp/python-lsp-server/blob/develop/CONFIGURATION.md
    capabilities = cmp_lsp.default_capabilities(),
    settings = {
        pylsp = {
            plugins = {
                ruff = {
                    ignore = {"E741"}
                },
                pylsp_mypy = {
                    overrides = {true, "--no-pretty"}
                }
            }
        }
    }
}

lspconfig.lua_ls.setup {
    capabilities = cmp_lsp.default_capabilities(),
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

lspconfig.texlab.setup{
    -- TODO: https://github.com/latex-lsp/texlab/wiki/Configuration
    capabilities = cmp_lsp.default_capabilities(),
    settings = {
        texlab = {
            chktex = {
                onEdit = true,
                onOpenAndSave = true
            },
            completion = {
                matcher = "prefix"
            }
        }
    }
}

require("lspconfig").bashls.setup{}

require("lspconfig").terraformls.setup{}
require("lspconfig").tflint.setup{}

vim.g.terraform_align = 1
vim.g.hcl_align = 1
vim.g.terraform_fmt_on_save = 1

--vim.cmd.packadd("grb256")
--vim.cmd.colorscheme("ff256")
