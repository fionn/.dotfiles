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
            },
            runtime = {version = "LuaJIT"},
            workspace = {
                checkThirdParty = false,
                library = {vim.env.VIMRUNTIME}
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
