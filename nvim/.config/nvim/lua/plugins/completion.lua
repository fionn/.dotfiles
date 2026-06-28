local cmp = require("cmp")
local context = require("cmp.config.context")

local kind_icons = {
    Text = "𝔞",
    Method = "𝑓",
    Function = "𝑓",
    Constructor  = "⛭",
    Field = "𝛼",
    Variable = "𝑥",
    Class  = "▤",
    Interface = "ɪ",
    Module = "▭",
    Property  = "𝑝",
    Unit = "¤",
    Value = "⎁",
    Enum = "ℤ",
    Keyword  = "⚿",
    Snippet = "✂",
    Color = "色",
    File = "⎘",
    Reference = "※",
    Folder = "/",
    EnumMember = "ℤ",
    Constant = "𝜋",
    Struct = "{}",
    Event  = "↯",
    Operator  = "⋆",
    TypeParameter = "𝑻"
}

local function has_words_before()
    -- Adapted from https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings.
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:
        sub(col, col):match("%s") == nil
end

---@param text string
---@param max_length integer
---@return string
local function truncate(text, max_length)
    if text and text:len() > max_length then
        return text:sub(1, max_length) .. "⋯"
    end
    return text
end

local function complete_match_or_abort()
    if cmp.get_selected_entry() or cmp.get_entries()[1].exact then
        cmp.confirm({select = true})
    else
        cmp.abort()
    end
end

cmp.setup({
    enabled = function()
        if vim.api.nvim_get_mode().mode == "c" then
            return true
        end
        -- Disable completion in comments.
        return not (context.in_treesitter_capture("comment")
            or context.in_syntax_group("Comment"))
    end,

    -- cmp claims that cmp.PreselectMode.None's type is an enum for string
    -- "None", but is actually an enum for "none" (lowercase), causing a type
    -- error.
    ---@diagnostic disable-next-line: assign-type-mismatch
    preselect = cmp.PreselectMode.None,

    completion = {autocomplete = false},

    formatting = {
        format = function(entry, vim_item)
            local sources = {
                nvim_lsp = "lsp",
                nvim_lsp_signature_help = "lsp-sig"
            }
            vim_item.abbr = truncate(vim_item.abbr, 30)
            vim_item.menu = sources[entry.source.name] or entry.source.name
            vim_item.kind = kind_icons[vim_item.kind] or vim_item.kind

            vim_item.dup = nil

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
        ["<Esc>"] = cmp.mapping.close(),
        ["<BS>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                if not has_words_before() then
                    cmp.close()
                else
                    -- The menu must be refreshed, since previous completions
                    -- were restricted to the prefix, which is now one character
                    -- shorter. cmp.ContextReason.Manual causes context.changed
                    -- to return true, regenerating the completion list.
                    cmp.complete({reason = cmp.ContextReason.Manual})
                end
            end
            fallback()
        end, {"i", "s"}),
        ["("] = cmp.mapping(function(_)
            if cmp.visible() then
                complete_match_or_abort()
            end
            vim.api.nvim_feedkeys("(", "n", false)
        end, {"i", "s"}),
        ["<CR>"] = cmp.mapping(function(fallback)
            if cmp.visible() and has_words_before() then
                complete_match_or_abort()
            else
                fallback()
            end
        end, {"i", "s"}),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                if #cmp.get_entries() == 1 then
                    cmp.confirm({select = true})
                elseif cmp.get_selected_entry()
                       or not cmp.complete_common_string() then
                    cmp.select_next_item()
                end
            elseif has_words_before() then
                cmp.complete({reason = cmp.ContextReason.Auto})
                local entry_count = #cmp.get_entries()
                if entry_count == 1 then
                    cmp.confirm({select = true})
                elseif entry_count > 1 then
                    cmp.complete_common_string()
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
            cmp.config.compare.sort_text,
            cmp.config.compare.score
        },
        priority_weight = 2
    },

    matching = {
        disallow_fuzzy_matching = true,
        disallow_fullfuzzy_matching = true,
        disallow_partial_fuzzy_matching = true,
        disallow_partial_matching = true,
        disallow_prefix_unmatching = true,
        disallow_symbol_nonprefix_matching = true
    },

    sources = cmp.config.sources {
        {name = "nvim_lsp"},
        {name = "nvim_lsp_signature_help"},
        {name = "omni"}
    }
} --[[@as cmp.ConfigSchema]])

cmp.setup.filetype("lua", {
    ---@type cmp.SourceConfig[]
    sources = cmp.config.sources {
        {name = "nvim_lsp"},
        {name = "nvim_lsp_signature_help"},
    }
})

cmp.setup.filetype("haskell", {
    ---@type cmp.SourceConfig[]
    sources = cmp.config.sources {
        {name = "nvim_lsp"},
        {name = "nvim_lsp_signature_help"},
        {name = "omni"},
        {name = "buffer", keyword_length = 2}
    }
})

cmp.setup.filetype("gitcommit", {
    ---@type cmp.SourceConfig[]
    sources = cmp.config.sources {
        {name = "git"},
        {name = "buffer", keyword_length = 2}
    }
})

-- Filetypes that I want to use buffer completion in -- typically text-heavy or
-- less structured than normal code.
local buffer_fts = {"text", "tex", "markdown", "mail", "dot", "yaml"}
for _, filetype in ipairs(buffer_fts) do
    cmp.setup.filetype(filetype, {
        ---@type cmp.SourceConfig[]
        sources = cmp.config.sources {
            {name = "nvim_lsp"},
            {name = "omni"},
            {name = "buffer", keyword_length = 2}
        }
    })
end

require("cmp_git").setup({
    git = {
        commits = {
            sha_length = 40
        }
    },
    github = {
        pull_requests = {
            state = "all",
            sort_by = function(pr)
                return 1 / tonumber(pr.number)
            end,
            limit = 40
        }
    }
})
