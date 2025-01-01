local common = require("common")

-- Automatically open quickfix window
local quickfix_group = vim.api.nvim_create_augroup("QuickFixGroup", { clear = true })
vim.api.nvim_create_autocmd({ "QuickFixCmdPost" }, {
    pattern = { "[^l]*" },
    command = "cwindow | setlocal nornu | setlocal nu",
    nested = true,
    group = quickfix_group,
})

-- Automatically open location list window
vim.api.nvim_create_autocmd({ "QuickFixCmdPost" }, {
    pattern = { "l*" },
    command = "lwindow | setlocal nornu | setlocal nu",
    nested = true,
    group = quickfix_group,
})

-- quickfix/location list toggling
local is_list_open = function(key)
    local info = vim.fn.getwininfo()
    for _, list in ipairs(info) do
        if list[key] == 1 then
            return true
        end
    end
    return false
end

local toggle_quickfix = function()
    if is_list_open("quickfix") then
        vim.cmd([[cclose]])
    else
        vim.cmd([[cwindow]])
    end
end

local toggle_loclist = function()
    if is_list_open("loclist") then
        vim.cmd([[lclose]])
    else
        vim.cmd([[lwindow]])
    end
end

vim.keymap.set("n", "<Leader>qq", function()
    toggle_quickfix()
end, { silent = true, desc = "Toggle quickfix window" })
vim.keymap.set("n", "<Leader>ll", function()
    toggle_loclist()
end, { silent = true, desc = "Toggle location list" })

-- mappings to go back and forth in quick fix & localtion list
common.create_expr_mapping_family({ "n" }, "q", "c", "quickfix list")
common.create_expr_mapping_family({ "n" }, "l", "l", "location list")

-- Filtering quickfix list
-- This enables Cfilter/Lfilter commands
vim.cmd([[packadd cfilter]])

-- Removes the current entry from the quickfix list
local remove_current_qf_entry = function()
    local list = vim.fn.getqflist()
    if list == nil or #list == 0 then
        return
    end

    local r, _ = unpack(vim.api.nvim_win_get_cursor(0))
    table.remove(list, r)
    vim.fn.setqflist(list, "r")

    if #list ~= 0 then
        vim.fn.execute("cfirst " .. r .. " | copen")
    else
        vim.api.nvim_err_writeln("No more entries in the quickfix list")
    end
end

-- map 'dd' in qf
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "qf" },
    callback = function()
        vim.keymap.set("n", "dd", function()
            remove_current_qf_entry()
        end, { buffer = true })
    end,
    group = quickfix_group,
})
