vim.opt_local.tabstop = 4
vim.opt_local.formatoptions = {
    ["1"] = true, -- break before single character words
    t = true, -- wrap
    n = true, -- indent lists
    a = true, -- auto-format
    q = true, -- format comments with gq
    w = true, -- use trailing whitespace as hint for paragraph end
    r = true, -- continue "comments" on new line
}
