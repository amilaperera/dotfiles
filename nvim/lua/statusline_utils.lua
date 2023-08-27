local get_truncating_method = function()
    return " %<"
end

local get_file = function()
    return "%t %h%m%r"
end

local get_git_info = function()
    local git_status = vim.fn.FugitiveHead()
    if git_status ~= nil and git_status ~= '' then
        return "%=(" .. git_status .. ")"
    end
    return ""
end

local get_file_type = function()
    local encoding = vim.opt.fenc:get()
    local encoding_str = ''
    if encoding ~= nil and encoding == '' then
        encoding_str = ''
    else
        encoding_str = ' | ' .. encoding .. ' '
    end
    return "%=" .. vim.o.filetype .. encoding_str
end

local get_location_info = function()
    return "%6.(%p%%%) %8.(%l,%c%) "
end

local M = {}

M.active_statusline = function()
    return get_truncating_method()
        ..get_file()
        ..get_git_info()
        ..get_file_type()
        ..get_location_info()
end

M.inactive_statusline = function()
    return get_truncating_method()
        ..get_file()
        .."%="
        ..get_location_info()
end

return M

