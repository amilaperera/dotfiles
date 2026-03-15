local common = require("common")
local devicons = require("nvim-web-devicons")

-- Module definitions
local AepStatusLine = {}

local H = {}

H.get_truncating_method = function()
    return "%<"
end

H.get_file = function()
    return " %t %h%m%r"
end

-- ignore git branch for following file types
H.git_ignore_types = function()
    return { "fugitive", "fugitiveblame", "git", "gitcommit", "NvimTree", "qf" }
end

H.get_file_type_icon = function(ft)
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

H.mode_map = {
    ["n"] = { short = "N", hl = "AepStatusLineNormalMode" },
    ["v"] = { short = "V", hl = nil },
    ["vs"] = { short = "V", hl = nil },
    ["V"] = { short = "V-L", hl = nil },
    ["Vs"] = { short = "V-L", hl = nil },
    ["\22"] = { short = "V-B", hl = nil },
    ["\22s"] = { short = "V-B", hl = nil },
    ["s"] = { short = "S", hl = nil },
    ["S"] = { short = "S-L", hl = nil },
    ["\19"] = { short = "S-B", hl = nil },
    ["i"] = { short = "I", hl = "AepStatusLineInsertMode" },
    ["R"] = { short = "R", hl = nil },
    ["c"] = { short = "C", hl = "AepStatusLineCommandMode" },
    ["r"] = { short = "P", hl = nil },
    ["!"] = { short = "Sh", hl = nil },
    ["t"] = { short = "T", hl = nil },
    ["Rc"] = { short = "R", hl = nil },
    ["Rx"] = { short = "R", hl = nil },
    ["Rv"] = { short = "V-R", hl = nil },
    ["Rvc"] = { short = "V-R", hl = nil },
    ["Rvx"] = { short = "V-R", hl = nil },
    ["rm"] = { short = "MORE", hl = nil },
    ["r?"] = { short = "CONF", hl = nil },
    ["no"] = { short = "O-P", hl = nil },
    ["nov"] = { short = "O-P", hl = nil },
    ["noV"] = { short = "O-P", hl = nil },
    ["no\22"] = { short = "O-P", hl = nil },
}

H.get_mode = function()
    local wrap = function(code)
        return " " .. code .. " "
    end

    local mode_code = vim.api.nvim_get_mode().mode
    if H.mode_map[mode_code] == nil then
        -- we have an unknown mode
        return "%#AepStatusLineModeInfoColor#" .. wrap(mode_code) .. "%*"
    end

    local color = H.mode_map[mode_code].hl == nil and "AepStatusLineModeInfoColor" or H.mode_map[mode_code].hl
    return "%#" .. color .. "#" .. wrap(H.mode_map[mode_code].short) .. "%*"
end

H.get_git_info = function()
    if vim.bo.buftype ~= "" then
        return ""
    end

    if common.table_contains(H.git_ignore_types(), vim.bo.filetype) == false then
        -- in case of a detached head state, truncate commit hash to 8 chars
        local git_status = vim.fn.FugitiveHead(8)
        if git_status ~= nil and git_status ~= "" then
            return " %#AepStatusLineGitBranch#" .. " " .. git_status .. "%*"
        end
    end
    return ""
end

H.get_file_type_and_encoding = function()
    local file_type = vim.bo.filetype
    local encoding = vim.bo.fileencoding or vim.bo.encoding

    -- filetype is undeducible
    if file_type == nil or file_type == "" then
        if encoding ~= nil and encoding ~= "" then
            -- even though the filetype is undeduced we see if we can work out an icon by extension
            return table.concat({ H.get_file_type_icon(nil), encoding, " " })
        end
        return ""
    end

    -- encoding is undeducible
    if encoding == nil or encoding == "" then
        if file_type ~= nil and file_type ~= "" then
            return table.concat({ H.get_file_type_icon(file_type), " ", file_type, " " })
        end
        return ""
    end

    return table.concat({
        H.get_file_type_icon(file_type),
        file_type,
        "  ",
        encoding,
        " ",
    })
end

H.get_location_info = function()
    return "%8.(%l:%c%) %4.(%p%%%)"
end

H.set_combined_color_group = function(name, opts)
    local fg_col = common.get_default_hl({ name = opts.fg })
    local bg_col = common.get_default_hl({ name = opts.bg })
    if fg_col == nil or bg_col == nil then
        return nil
    end
    common.set_default_hl(name, { fg = fg_col.fg, bg = bg_col.bg })
end

AepStatusLine.active = function()
    return table.concat({
        H.get_truncating_method(),
        -- H.get_mode(),
        H.get_git_info(),
        H.get_file(),
        "%=",
        H.get_file_type_and_encoding(),
        H.get_location_info(),
    })
end

AepStatusLine.inactive = function()
    return table.concat({
        H.get_truncating_method(),
        H.get_file(),
        "%=",
        H.get_location_info(),
    })
end

H.update = vim.schedule_wrap(function()
    local cur_win_id = vim.api.nvim_get_current_win()
    for _, win_id in ipairs(vim.api.nvim_list_wins()) do
        vim.wo[win_id].statusline = win_id == cur_win_id and "%{%v:lua.AepStatusLine.active()%}"
            or "%{%v:lua.AepStatusLine.inactive()%}"
    end
end)

AepStatusLine.setup = function(config)
    _G.AepStatusLine = AepStatusLine

    vim.g.laststatus = 2
    vim.opt.showmode = true
    -- We discard return code as there's nothing much can do if the hl group can't be found
    H.set_combined_color_group("AepStatusLineGitBranch", { fg = "String", bg = "StatusLine" })
    H.set_combined_color_group("AepStatusLineModeInfoColor", { fg = "Visual", bg = "Visual" })
    H.set_combined_color_group("AepStatusLineNormalMode", { fg = "Title", bg = "Title" })
    H.set_combined_color_group("AepStatusLineInsertMode", { fg = "IncSearch", bg = "IncSearch" })
    H.set_combined_color_group("AepStatusLineCommandMode", { fg = "DiffAdd", bg = "DiffAdd" })

    H.update()

    local augroup = vim.api.nvim_create_augroup("AepStatusLineGroup", { clear = true })
    vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
        pattern = "*",
        callback = H.update,
        group = augroup,
    })
end

return AepStatusLine
