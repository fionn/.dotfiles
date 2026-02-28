local function add_struct_tags()
    vim.lsp.buf.code_action({
        context = {
            diagnostics = {},
            only = {"refactor.rewrite"},
        },
        filter = function(action)
            return action.kind == "refactor.rewrite.addTags"
        end,
        apply = true
    })
end

vim.api.nvim_create_user_command("GoAddTags", add_struct_tags, {desc = "Add struct tags"})

vim.opt_local.colorcolumn = {80, 100}
vim.opt_local.formatoptions:append({
    r = true,
    o = true,
    ["/"] = true
}) -- Keep comment leader
