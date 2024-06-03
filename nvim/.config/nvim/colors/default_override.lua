vim.g.colors_name = "default_override"

-- Default colours are defined in
-- https://github.com/neovim/neovim/blob/master/src/nvim/highlight_group.c.

local highlights = {
    Normal = {bg = "#0c0c0f"},

    ColorColumn = {bg = "#121212"},

    CursorLineNr = {bold = false, fg="#adadad"},

    Visual = {bg = "#323232"},

    Added = {fg = "Green"},
    Changed = {fg = "#bbbb00"},
    Removed = {fg = "Red"},

    Comment = {italic = true, fg = "#6a6a6a"},
    Function = {fg = "NvimLightYellow"},
    Special = {link = "Function"},
    Number = {fg = "LightMagenta"},
    Constant= {fg = "SteelBlue1"},
    PreProc = {fg = "CornflowerBlue"},
    Statement = {fg = "NvimLightBlue"},
    Type = {fg = "Goldenrod2"},
    Boolean = {link = "Number"},

    DiagnosticError = {fg = "DarkRed"},
    DiagnosticVirtualTextError = {fg = "NvimDarkRed", bg = "#1a0000"},
    DiagnosticUnderlineError = {undercurl = true, sp = "NvimDarkRed"},

    DiagnosticWarn = {fg = "DarkYellow"},
    DiagnosticVirtualTextWarn = {fg = "NvimDarkYellow", bg = "#0f0f00"},
    DiagnosticUnderlineWarn = {undercurl = true, sp = "NvimDarkYellow"},

    DiagnosticInfo = {fg = "SteelBlue"},
    DiagnosticVirtualTextInfo = {fg = "NvimDarkBlue", bg = "#00001a"},
    DiagnosticUnderlineInfo = {undercurl = true, sp = "NvimDarkBlue"},

    DiagnosticHint = {fg = "DarkGreen"},
    DiagnosticVirtualTextHint = {fg = "NvimDarkGreen", bg = "#001a00"},
    DiagnosticUnderlineHint = {undercurl = true, sp = "NvimDarkGreen"},

    DiagnosticUnnecessary = {},

    ["@function.builtin"] = {link = "Function"},
    ["@keyword.import"] = {link = "Include"},
    ["@keyword.directive"] = {fg = "SteelBlue4"},
    ["@constructor"] = {link = "Type"},
    ["@constructor.lua"] = {link = "Delimiter"},
    ["@markup.raw"] = {bg = "NvimDarkGrey3"},
    ["@markup.raw.block.vimdoc"] = {},
    ["@markup.quote"] = {fg = "NvimLightGrey4"},
    ["@markup.list"] = {link = "Number"},
    ["@tag.attribute"] = {link = "PreProc"}
}

for group, options in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, options)
end
