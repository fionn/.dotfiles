-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local lspconfig = require("lspconfig")

capabilities.textDocument.completion.completionItem.snippetSupport = false

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
                mccabe = {enabled = false},
                pycodestyle = {enabled = false},
                pyflakes = {enabled = false},
                rope = {save_objectdb = false},
                pylsp_mypy = {
                    -- Once https://github.com/python-lsp/pylsp-mypy/pull/83
                    -- makes it mainstream (0.6.9), we can drop this override.
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
            hint = {enable = true},
            format = {
                defaultConfig = {
                    quote_style = "double",
                    trailing_table_separator = "never",
                    space_around_table_field_list = false,
                    align_function_params = true
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
    capabilities = capabilities,
    settings = {
        texlab = {
            forwardSearch = {
                executable = "zathura",
                args = {"--synctex-forward", "%l:1:%f", "%p"}
            },
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

lspconfig.gopls.setup {
    capabilities = capabilities,
    settings = {
        gopls = {
            hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true
            }
        }
    }
}

lspconfig.golangci_lint_ls.setup {}
lspconfig.bashls.setup {}
lspconfig.terraformls.setup {}
lspconfig.tflint.setup {}
lspconfig.marksman.setup {}
lspconfig.yamlls.setup {}
