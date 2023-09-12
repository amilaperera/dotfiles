local utils = require('utils')

local get_truncating_method = function()
    return "%<"
end

local get_file = function()
    return "%t %h%m%r"
end

-- ignore git branch for following file types
local git_ignore_types = {'fugitive', 'NvimTree'}

local get_git_info = function()
    if utils.table_contains(git_ignore_types, vim.bo.filetype) == false then
        local git_status = vim.fn.FugitiveHead()

        if git_status ~= nil and git_status ~= '' then
            return "%=(" .. "%#StatuslineGitBranch#" .. git_status .. "%*" .. ")"
        end
    end
    return ""
end

local get_file_type_and_encoding = function()
    local file_type = vim.bo.filetype
    local encoding = vim.bo.fileencoding

    -- filetype is undeducible
    if file_type == nil or file_type == '' then
        if encoding ~= nil and encoding ~= '' then
            return table.concat({encoding, ' '})
        end
        return ''
    end

    -- encoding is undeducible
    if encoding == nil and encoding == '' then
        if file_type ~= nil and file_type ~= '' then
            return table.concat({file_type, ' '})
        end
        return ''
    end

    return table.concat({vim.o.filetype, "  ", encoding .. ' '})
end

local get_location_info = function()
    return "%8.(%l:%c%) %4.(%p%%%)"
end

local M = {}

M.active_statusline = function()
    return table.concat({
        get_truncating_method(),
        get_file(),
        get_git_info(),
        "%=",
        get_file_type_and_encoding(),
        get_location_info()
    });
end

M.inactive_statusline = function()
    return table.concat ({
        get_truncating_method(),
        get_file(),
        "%=",
        get_location_info()
    });
end

return M

