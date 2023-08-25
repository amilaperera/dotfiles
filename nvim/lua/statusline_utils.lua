local get_file = function()
    return " %f %h%m%r"
end

local get_git_info = function()
    return ""
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

local M = {}

M.active_statusline = function()
    return get_file()..get_git_info()..get_file_type()..get_location_info()
end

return M

