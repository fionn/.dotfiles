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

vim.api.nvim_create_autocmd("LspAttach", {
    desc = "Meta-level codelens support",
    group = vim.api.nvim_create_augroup("codelens", {clear = true}),
    pattern = {"*.go", "go.mod"},
    callback = function(args)
        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client:supports_method("textDocument/codeLens") then
            vim.lsp.codelens.enable(true, {bufnr = bufnr})
            vim.api.nvim_create_autocmd({"BufEnter", "CursorHold", "InsertLeave"}, {
                desc = "Refresh codelenses",
                group = "codelens",
                buffer = bufnr,
                callback = function()
                    vim.lsp.codelens.enable(true, {bufnr = bufnr})
                end
            })
            vim.api.nvim_create_autocmd("InsertEnter", {
                desc = "Clear codelenses",
                group = "codelens",
                buffer = bufnr,
                callback = function()
                    vim.lsp.codelens.enable(false, {bufnr = bufnr})
                end
            })
        end
    end,
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("highlight_on_hover", {clear = true}),
    callback = function(ev)
        local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
        if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight)
           and client:supports_method(vim.lsp.protocol.Methods.textDocument_hover) then
            vim.keymap.set("n", "K",
                function()
                    vim.lsp.buf.hover()
                    vim.lsp.buf.document_highlight()
                end,
                {desc = "Hover", buffer = ev.buf})

            vim.api.nvim_create_autocmd({"CursorMoved", "InsertEnter"}, {
                group = "highlight_on_hover",
                desc = "Clear source and reference highlights",
                buffer = ev.buf,
                callback = vim.lsp.buf.clear_references
            })
        end
    end
})

vim.api.nvim_create_autocmd("LspAttach", {
    desc = "Configure document color",
    group = vim.api.nvim_create_augroup("document_color", {clear = true}),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client:supports_method("textDocument/documentColor") then
            vim.lsp.document_color.enable(true, {client_id = client.id}, {style = "virtual"})
        end
    end,
})

vim.lsp.config("pylsp", {
    -- TODO: configure this.
    -- https://github.com/python-lsp/python-lsp-server/blob/develop/CONFIGURATION.md
    ---@type lspconfig.settings.pylsp
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
    ---@type lspconfig.settings.lua_ls
    settings = {
        Lua = {
            completion = {
                keywordSnippet = "Disable"
            },
            hint = {enable = true},
            codeLens = {enable = false},
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
                library = {
                    vim.env.VIMRUNTIME,
                    vim.fn.stdpath("data") .. "/site/pack/core/opt/nvim-lspconfig/lua/lspconfig"
                }
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
            semanticTokens = true,
            semanticTokenTypes = {
                variable = false,
            },
            hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true
            },
            codelenses = {
                regenerate_cgo = false,
                test = true,
                vendor = false,
                tidy = false
            }
        }
    }
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
