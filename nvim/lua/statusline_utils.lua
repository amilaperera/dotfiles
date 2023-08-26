local get_truncating_method = function()
    return " %<"
end

local get_file = function()
    return "%t %h%m%r"
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
    return "%5.(%p%%%) %6.(%l,%c%) "
end

local M = {}

M.active_statusline = function()
    return get_truncating_method()
        ..get_file()
        ..get_git_info()
        ..get_file_type()
        ..get_location_info()
end

return M

