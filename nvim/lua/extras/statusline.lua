vim.g.laststatus = 2

local common = require("common")
local devicons = require("nvim-web-devicons")

local get_truncating_method = function()
    return "%<"
end

local get_file = function()
    return "%t %h%m%r"
end

-- ignore git branch for following file types
local git_ignore_types = { "fugitive", "fugitiveblame", "git", "gitcommit", "NvimTree", "qf" }

local get_file_type_icon = function(ft)
    -- retrieve by filename
    local file_type_icon = devicons.get_icon(vim.fn.expand("%:t"), vim.fn.expand("%:e"))
    if ft ~= nil and file_type_icon == nil then
        -- now by filetype
        file_type_icon = devicons.get_icon_by_filetype(ft)
    end

    if file_type_icon == nil then
        file_type_icon = ""
    else
        file_type_icon = file_type_icon .. " "
    end
    return file_type_icon
end

local get_git_info = function()
    if common.table_contains(git_ignore_types, vim.bo.filetype) == false then
        -- in case of a detached head state, truncate commit hash to 8 chars
        local git_status = vim.fn.FugitiveHead(8)
        if git_status ~= nil and git_status ~= "" then
            return "%#AepStatusLineGitBranch#" .. " " .. git_status .. "%* "
        end
    end
    return ""
end

local get_file_type_and_encoding = function()
    local file_type = vim.bo.filetype
    local encoding = vim.bo.fileencoding or vim.bo.encoding

    -- filetype is undeducible
    if file_type == nil or file_type == "" then
        if encoding ~= nil and encoding ~= "" then
            -- even though the filetype is undeduced we see if we can work out an icon by extension
            return table.concat({ get_file_type_icon(nil), encoding, " " })
        end
        return ""
    end

    -- encoding is undeducible
    if encoding == nil or encoding == "" then
        if file_type ~= nil and file_type ~= "" then
            return table.concat({ get_file_type_icon(file_type), " ", file_type, " " })
        end
        return ""
    end

    return table.concat({
        get_file_type_icon(file_type),
        file_type,
        "  ",
        encoding,
        " ",
    })
end

local get_location_info = function()
    return "%8.(%l:%c%) %4.(%p%%%)"
end

local set_combined_color_group = function(name, opts)
    local fg_col = common.get_default_hl({ name = opts.fg })
    local bg_col = common.get_default_hl({ name = opts.bg })
    if fg_col == nil or bg_col == nil then
        return nil
    end
    common.set_default_hl(name, { fg = fg_col.fg, bg = bg_col.bg })
end

local M = {}

M.config = function()
    set_combined_color_group("AepStatusLineGitBranch", { fg = "String", bg = "StatusLine" })
end

M.active_statusline = function()
    return table.concat({
        get_truncating_method(),
        get_git_info(),
        get_file(),
        "%=",
        get_file_type_and_encoding(),
        get_location_info(),
    })
end

M.inactive_statusline = function()
    return table.concat({
        get_truncating_method(),
        get_file(),
        "%=",
        get_location_info(),
    })
end

return M
