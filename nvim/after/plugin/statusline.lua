vim.g.laststatus = 2

local common = require('common')
local devicons = require('nvim-web-devicons')

local get_truncating_method = function()
    return "%<"
end

local get_file = function()
    return "%t %h%m%r"
end

-- ignore git branch for following file types
local git_ignore_types = {'fugitive', 'fugitiveblame', 'git', 'gitcommit', 'NvimTree', 'qf'}

local get_file_type_icon = function(ft)
    local file_type_icon = devicons.get_icon_by_filetype(ft)
    if file_type_icon == nil then
        file_type_icon = ''
    else
        file_type_icon = file_type_icon .. ' '
    end
    return file_type_icon
end

local get_git_info = function()
    if common.table_contains(git_ignore_types, vim.bo.filetype) == false then
        -- in case of a detached head state, truncate commit hash to 8 chars
        local git_status = vim.fn.FugitiveHead(8)

        if git_status ~= nil and git_status ~= '' then
            return "%=" .. "%#StatuslineGitBranch#" .. ' ' .. git_status .. "%*"
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
            return table.concat({get_file_type_icon(file_type), ' ', file_type, ' '})
        end
        return ''
    end

    return table.concat({
        get_file_type_icon(file_type),
        file_type, '  ',
        encoding, ' '
    })
end

local get_location_info = function()
    return "%8.(%l:%c%) %4.(%p%%%)"
end

_G.aep_active_statusline = function()
    return table.concat({
        get_truncating_method(),
        get_file(),
        get_git_info(),
        "%=",
        get_file_type_and_encoding(),
        get_location_info()
    });
end

_G.aep_inactive_statusline = function()
    return table.concat({
        get_truncating_method(),
        get_file(),
        "%=",
        get_location_info()
    });
end

local statusline_group = vim.api.nvim_create_augroup("StatuslineGroup", { clear = true })
vim.api.nvim_create_autocmd({"WinEnter", "BufEnter"}, {
    pattern = {"*"},
    callback = function ()
        vim.api.nvim_exec([[setlocal statusline=%!v:lua.aep_active_statusline()]], false)
    end,
    group = statusline_group
})

vim.api.nvim_create_autocmd({"WinLeave", "BufLeave"}, {
    pattern = {"*"},
    callback = function ()
        vim.api.nvim_exec([[setlocal statusline=%!v:lua.aep_inactive_statusline()]], false)
    end,
    group = statusline_group
})
