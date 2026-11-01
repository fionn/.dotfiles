---@return string?
local function get_identity()
    local out = vim.system({"git", "var", "GIT_AUTHOR_IDENT"}, {text = true}):wait(1000)
    if out.code ~= 0 then
        vim.notify("Failed to get identity from Git configuration",
            vim.log.levels.WARN)
        return
    end

    local name, email = assert(out.stdout):match("^(.-) <([^>]+)>")
    return assert(name) .. " <" .. assert(email) .. ">"
end

local identity = get_identity()
if identity ~= nil then
    vim.g.changelog_username = identity
end
