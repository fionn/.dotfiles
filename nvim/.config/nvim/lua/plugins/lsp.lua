-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
local capabilities = require("cmp_nvim_lsp").default_capabilities()

capabilities.textDocument.completion.completionItem.snippetSupport = false

vim.lsp.enable("bashls")
vim.lsp.enable("pylsp")
vim.lsp.enable("lua_ls")
vim.lsp.enable("gopls")
vim.lsp.enable("golangci_lint_ls")
vim.lsp.enable("hls")
vim.lsp.enable("clangd")
vim.lsp.enable("rust_analyzer")
vim.lsp.enable("terraformls")
vim.lsp.enable("tflint")
vim.lsp.enable("marksman")
vim.lsp.enable("yamlls")
vim.lsp.enable("texlab")
vim.lsp.enable("helm_ls")
vim.lsp.enable("ts_ls")

vim.lsp.config("pylsp", {
    -- TODO: configure this.
    -- https://github.com/python-lsp/python-lsp-server/blob/develop/CONFIGURATION.md
    settings = {
        pylsp = {
            plugins = {
                mccabe = {enabled = false},
                pycodestyle = {enabled = false},
                pyflakes = {enabled = false},
                preload = {enabled = false},
                ruff = {ignore = {"D"}},
                rope = {save_objectdb = false},
                pylsp_mypy = {
                    -- Once https://github.com/python-lsp/pylsp-mypy/pull/83
                    -- makes it mainstream (0.6.9), we can drop this override.
                    overrides = {true, "--no-pretty"}
                }
            }
        }
    }
})

vim.lsp.config("lua_ls",  {
    settings = {
        Lua = {
            completion = {
                keywordSnippet = "Disable"
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
})

vim.lsp.config("texlab", {
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
})

vim.lsp.config("gopls", {
    settings = {
        gopls = {
            matcher = "caseSensitive",
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
})

vim.lsp.config("golangci_lint_ls", {
    -- This can be removed once the language server gets a release that
    -- includes https://github.com/nametake/golangci-lint-langserver/pull/55
    -- (see https://github.com/nametake/golangci-lint-langserver/issues/64).
    filetypes = {"go"}
})

vim.lsp.config("helm_ls", {
    settings = {
        ["helm-ls"] = {
            yamlls = {showDiagnosticsDirectly = true}
        }
    }
})

vim.lsp.config("*", {
    capabilities = capabilities
})
