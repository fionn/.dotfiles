require("ts-install").setup {
    ensure_install = {"lua", "query"},
    auto_install = true,
    auto_update = false
}

require("treesitter-context").setup {
    max_lines = 2,
    min_window_height = 3,
    multiline_threshold = 3,
    trim_scope = "inner",
    mode = "cursor",
    separator = "‾"
}

require("nvim-treesitter-textobjects").setup {
    select = {
        lookahead = true,
        selection_modes = {
            ["@parameter.outer"] = "v",
            ["@function.inner"] = "V",
            ["@function.outer"] = "V",
            ["@block.inner"] = "V",
            ["@block.outer"] = "V",
            ["@class.outer"] = "<C-v>"
        }
    },
    set_jumps = true
}

local ts_to_select = require("nvim-treesitter-textobjects.select")
local ts_to_swap = require("nvim-treesitter-textobjects.swap")
local ts_to_move = require("nvim-treesitter-textobjects.move")

---@param query_string string
---@param query_group? string
local function select(query_string, query_group)
    return function()
        ts_to_select.select_textobject(query_string, query_group or "textobjects")
    end
end

vim.keymap.set({"x","o"}, "if", select("@function.inner"), {desc = "inner @function"})
vim.keymap.set({"x","o"}, "af", select("@function.outer"), {desc = "outer @function"})
vim.keymap.set({"x","o"}, "ik", select("@block.inner"), {desc = "inner @block"})
vim.keymap.set({"x","o"}, "ak", select("@block.outer"), {desc = "outer @block"})
vim.keymap.set({"x","o"}, "ic", select("@class.inner"), {desc = "inner @class"})
vim.keymap.set({"x","o"}, "ac", select("@class.outer"), {desc = "outer @class"})
vim.keymap.set({"x","o"}, "as", select("@local.scope", "locals"), {desc = "local @scope"})

local swap = {}

---@param query_strings string | string[]
---@param query_group? string
function swap.next(query_strings, query_group)
    return function()
        ts_to_swap.swap_next(query_strings, query_group or "textobjects")
    end
end

---@param query_strings string | string[]
---@param query_group? string
function swap.previous(query_strings, query_group)
    return function()
        ts_to_swap.swap_previous(query_strings, query_group or "textobjects")
    end
end

vim.keymap.set("n", "<leader>sn", swap.next({"@parameter.inner", "@function.outer"}), {desc = "Swap next @parameter or @function"})
vim.keymap.set("n", "<leader>sp", swap.previous({"@parameter.inner", "@function.outer"}), {desc = "Swap previous @parameter or @function"})

local move = {}

---@param query_strings string | string[]
---@param query_group? string
function move.next_start(query_strings, query_group)
    return function()
        ts_to_move.goto_next_start(query_strings, query_group)
    end
end

---@param query_strings string | string[]
---@param query_group? string
function move.previous_start(query_strings, query_group)
    return function()
        ts_to_move.goto_previous_start(query_strings, query_group)
    end
end

---@param query_strings string | string[]
---@param query_group? string
function move.next_end(query_strings, query_group)
    return function()
        ts_to_move.goto_next_end(query_strings, query_group)
    end
end

---@param query_strings string | string[]
---@param query_group? string
function move.previous_end(query_strings, query_group)
    return function()
        ts_to_move.goto_previous_end(query_strings, query_group)
    end
end

vim.keymap.set({"n", "x", "o"}, "]m", move.next_start("@function.outer"), {desc = "Next @function start"})
vim.keymap.set({"n", "x", "o"}, "[m", move.previous_start("@function.outer"), {desc = "Previous @function start"})
vim.keymap.set({"n", "x", "o"}, "]M", move.next_end("@function.outer"), {desc = "Next @function end"})
vim.keymap.set({"n", "x", "o"}, "[M", move.previous_end("@function.outer"), {desc = "Previous @function end"})
vim.keymap.set({"n", "x", "o"}, "]o", move.next_start({"@loop.inner", "@loop.outer"}), {desc = "Next @loop start"})
vim.keymap.set({"n", "x", "o"}, "]z", move.next_start("@fold", "folds"), {desc = "Next @fold"})

vim.api.nvim_create_autocmd("FileType", {
    desc = "Start Treesitter",
    group = vim.api.nvim_create_augroup("TreeSitter", {clear = true}),
    callback = function(event)
        local no_indent = {"python"}
        if not vim.tbl_contains(no_indent, event.match) then
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end

        local no_hl = {"gitcommit", "diff", "markdown"}
        if vim.tbl_contains(no_hl, event.match) then
            return
        end

        pcall(vim.treesitter.start)
    end
})
