local M = {}

local is_list_open = function(key)
    local info = vim.fn.getwininfo()
    for _, list in ipairs(info) do
        if list[key] == 1 then
            return true
        end
    end
    return false
end

M.toggle_quickfix = function()
    if is_list_open('quickfix') then
        vim.cmd[[cclose]]
    else
        vim.cmd[[copen]]
    end
end

M.toggle_loclist = function()
    if is_list_open('loclist') then
        vim.cmd[[lclose]]
    else
        vim.cmd[[lopen]]
    end
end

return M
