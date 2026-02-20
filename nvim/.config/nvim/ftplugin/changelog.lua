local function set_username()
    local name_proc = vim.system({"git", "config", "get", "user.name"})
    local email_proc = vim.system({"git", "config", "get", "user.email"})

    local name = name_proc:wait()
    local email = email_proc:wait()

    if name.code ~= 0 or email.code ~= 0 then
        vim.notify("Failed to set changelog username from Git configuration", vim.log.levels.WARN)
        return
    end

    vim.g.changelog_username = vim.trim(name.stdout) .. " <" .. vim.trim(email.stdout) .. ">"
end

set_username()
