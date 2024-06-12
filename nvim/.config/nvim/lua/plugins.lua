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
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
    "nvim-treesitter/nvim-treesitter-textobjects",
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    "lewis6991/gitsigns.nvim",
    "FabijanZulj/blame.nvim",
    "godlygeek/tabular",
    "hashivim/vim-terraform",
    {"fionn/grb256", opt = true}
}

-- TREESITTER

require("nvim-treesitter.configs").setup {
    ensure_installed = {"c", "lua", "vim", "vimdoc", "query", "diff"},
    sync_install = false,
    auto_install = true,
    highlight = {
        enable = true,
        disable = {
            "gitcommit"
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

-- GITSIGNS

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

-- BLAME

require("blame").setup {
    date_format = "%Y-%m-%d"
}

-- CMP

local cmp = require("cmp")
local cmp_lsp = require("cmp_nvim_lsp")

local kind_icons = {
    Method = "𝑓",
    Function = "𝑓",
    Variable = "𝑥",
    Snippet = "✂",
    Constant = "𝜋",
    TypeParameter = "𝑻",
    Interface = "ɪ",
    Module = "▭"
}

local function has_words_before()
    -- From https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings.
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:
        sub(col, col):match("%s") == nil
end

---@param text string
---@param max_length integer
---@return string
local function truncate(text, max_length)
    if text and text:len() > max_length then
        text = text:sub(1, max_length) .. "⋯"
    end
    return text
end

cmp.setup {
    enabled = function()
        -- disable completion in comments
        local context = require("cmp.config.context")
        if vim.api.nvim_get_mode().mode == "c" then
            return true
        else
            return not context.in_treesitter_capture("comment")
                and not context.in_syntax_group("Comment")
        end
    end,

    preselect = cmp.PreselectMode.None,

    completion = {
        autocomplete = false
    },

    formatting = {
        format = function(_, vim_item)
            vim_item.abbr = truncate(vim_item.abbr, 30)
            vim_item.menu = truncate(vim_item.menu, 30)
            vim_item.info = truncate(vim_item.info, 30)

            vim_item.kind = kind_icons[vim_item.kind] or vim_item.kind

            vim_item.dup = 0

            return vim_item
        end
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
        ["<Esc>"] = cmp.mapping.close(),
        ["<CR>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.mapping.confirm({select = false})
            end
            cmp.abort()
            fallback()
        end, {"i", "s"}),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                if #cmp.get_entries() == 1 then
                    cmp.confirm({ select = true })
                elseif cmp.get_selected_entry() then
                    cmp.select_next_item()
                elseif not cmp.complete_common_string() then
                    cmp.select_next_item()
                end
            elseif has_words_before() then
                cmp.complete({reason = "manual"})
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

    sorting = {
        comparators = {
            cmp.config.compare.exact,
            cmp.config.compare.sort_text
        }
    },

    matching = {
        disallow_fuzzy_matching = true,
        disallow_fullfuzzy_matching = true,
        disallow_partial_fuzzy_matching = true,
        disallow_partial_matching = true,
        disallow_prefix_unmatching = true
    },

    sources = cmp.config.sources({
        {name = "nvim_lsp"},
        {name = "nvim_lsp_signature_help"},
        {name = "buffer"}
    })
}

-- LSPCONFIG

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
local lspconfig = require("lspconfig")
require("lspconfig.ui.windows").default_options.border = "rounded"

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

-- TERRAFORM

vim.g.terraform_align = 1
vim.g.hcl_align = 1
vim.g.terraform_fmt_on_save = 1

-- LSP_LINES

require("lsp_lines").setup()
