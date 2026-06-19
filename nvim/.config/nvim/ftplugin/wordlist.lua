vim.opt_local.comments = ":#"
vim.opt_local.commentstring = "# %s"
vim.opt_local.spell = true

local augroup = vim.api.nvim_create_augroup("wordlist", {})
local pattern = "*.add"

vim.api.nvim_create_autocmd("BufWrite", {
    group = augroup,
    desc = "Meta-level compile spellfile from wordlist",
    pattern = pattern,
    callback = function()
        if vim.opt_local.modified:get() == true then
            vim.api.nvim_create_autocmd("BufWritePost", {
                group = augroup,
                desc = "Compile spellfile from wordlist",
                pattern = pattern,
                callback = function()
                    vim.cmd.mkspell({"%", bang = true})
                    -- Return true to run once.
                    return true
                end
            })
        end
    end
})
