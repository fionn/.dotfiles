---@return string?
local function get_identity()
    local name_proc = vim.system(
        {"git", "config", "get", "user.name"}, {text = true})
    local email_proc = vim.system(
        {"git", "config", "get", "user.email"}, {text = true})

    local name = name_proc:wait(1000)
    local email = email_proc:wait(1000)

    if name.code ~= 0 or email.code ~= 0 then
        vim.notify("Failed to get identity from Git configuration",
            vim.log.levels.WARN)
        return
    end

    return vim.trim(assert(name.stdout)) .. " <" .. vim.trim(assert(email.stdout)) .. ">"
end

local identity = get_identity()
if identity ~= nil then
    vim.g.changelog_username = identity
end
