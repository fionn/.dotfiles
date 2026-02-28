-- We use a protected call because the keymap might not exist (for
-- example, we might have already deleted it).
pcall(function() vim.api.nvim_buf_del_keymap(0, "n", "<C-l>") end)
