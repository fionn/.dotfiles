local cmp = require("cmp")

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

---@param key string
local function complete_match_or_abort(key)
    -- Undocumented API!
    if cmp.get_selected_entry() or cmp.get_entries()[1].exact then
        cmp.confirm({select = true})
    else
        cmp.abort()
    end
    vim.api.nvim_feedkeys(key, "n", false)
end

cmp.setup {
    enabled = function()
        if vim.api.nvim_get_mode().mode == "c" then
            return true
        else
            -- Disable completion in comments.
            local context = require("cmp.config.context")
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
        ["<BS>"] = cmp.mapping(function(fallback)
            if cmp.visible() and not has_words_before() then
                cmp.abort()
            end
            fallback()
        end, {"i", "s"}),
        ["("] = cmp.mapping(function(fallback)
            if cmp.visible() then
                complete_match_or_abort("(")
            else
                fallback()
            end
        end, {"i", "s"}),
        ["<Space>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                complete_match_or_abort(" ")
            else
                fallback()
            end
        end, {"i", "s"}),
        ["<CR>"] = cmp.mapping(function(fallback)
            if cmp.visible() and has_words_before() then
                local cr = vim.api.nvim_replace_termcodes("<CR>", true, true, true)
                complete_match_or_abort(cr)
            else
                cmp.abort()
                fallback()
            end
        end, {"i", "s"}),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                if #cmp.get_entries() == 1 then
                    cmp.confirm({select = true})
                elseif cmp.get_selected_entry() then
                    cmp.select_next_item()
                elseif not cmp.complete_common_string() then
                    cmp.select_next_item()
                end
            elseif has_words_before() then
                cmp.complete({reason = cmp.ContextReason.Manual})
                if #cmp.get_entries() == 1 then
                    cmp.confirm({select = true})
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

    sources = cmp.config.sources {
        {name = "nvim_lsp"},
        {name = "nvim_lsp_signature_help"},
        {name = "nvim_lua"},
        {name = "buffer"},
        {name = "unitex"}
    }
}

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local lspconfig = require("lspconfig")
require("lspconfig.ui.windows").default_options.border = "rounded"

lspconfig.clangd.setup {
    capabilities = capabilities
}

lspconfig.rust_analyzer.setup {
    capabilities = capabilities
}

lspconfig.pylsp.setup {
    -- TODO: configure this.
    -- https://github.com/python-lsp/python-lsp-server/blob/develop/CONFIGURATION.md
    capabilities = capabilities,
    settings = {
        pylsp = {
            plugins = {
                ruff = {
                    ignore = {"E741"}
                },
                pylsp_mypy = {
                    -- Once https://github.com/python-lsp/pylsp-mypy/pull/83
                    -- makes it mainstream, we can drop this override.
                    overrides = {true, "--no-pretty"}
                }
            }
        }
    }
}

lspconfig.lua_ls.setup {
    capabilities = capabilities,
    settings = {
        Lua = {
            completion = {
                keywordSnippet = "Disable"
            },
            diagnostics = {
                globals = {"vim"}
            },
            format = {
                defaultConfig = {
                    quote_style = "double",
                    trailing_table_separator = "never",
                    space_around_table_field_list = "false",
                    align_function_params = "true"
                }
            }
        }
    }
}

lspconfig.texlab.setup {
    -- TODO: https://github.com/latex-lsp/texlab/wiki/Configuration
    capabilities = capabilities,
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

lspconfig.bashls.setup {}
lspconfig.terraformls.setup {}
lspconfig.tflint.setup {}
lspconfig.gopls.setup {}
lspconfig.marksman.setup {}
lspconfig.yamlls.setup {}
