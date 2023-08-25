StatusLine = {}

local get_file = function()
    return " %t %m %r %h"
end

local get_file_type = function()
    local encoding = vim.opt.fenc:get()
    local encoding_str = '[unknown]'
    if encoding ~= nil and encoding == '' then
        encoding_str = ''
    else
        encoding_str = '[' .. encoding .. ']'
    end
    return "%= %y " .. encoding_str
end

local get_location_info = function()
    return " %- %4p%% %5l:%c / %L "
end

local get_git_info = function()
    local info = vim.b.gitsigns_status_dict
    if not info or info.head == "" then
        return ""
    end
    return "Git(" .. info.head .. ") +" .. info.added .. " -" .. info.removed .. " ~" .. info.changed
end

StatusLine.active_statusline = function()
    return get_file()..get_git_info()..get_file_type()..get_location_info()
end

vim.api.nvim_exec([[set statusline=%!v:lua.StatusLine.active_statusline()]], false)
