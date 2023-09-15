local utils = require('utils')

-- Automatically open quickfix window
local quickfix_group = vim.api.nvim_create_augroup("QuickFixGroup", { clear = true })
vim.api.nvim_create_autocmd({"QuickFixCmdPost"}, {
    pattern = {"[^l]*"},
    command = "cwindow",
    nested = true,
    group = quickfix_group
})

-- Automatically open location list window
vim.api.nvim_create_autocmd({"QuickFixCmdPost"}, {
    pattern = {"l*"},
    command = "lwindow",
    nested = true,
    group = quickfix_group
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
    if is_list_open('quickfix') then
        vim.cmd[[cclose]]
    else
        vim.cmd[[cwindow]]
    end
end

local toggle_loclist = function()
    if is_list_open('loclist') then
        vim.cmd[[lclose]]
    else
        vim.cmd[[lwindow]]
    end
end

vim.keymap.set("n", "<Leader>q", function() toggle_quickfix() end, { silent = true, desc = "Toggle quickfix window" })
vim.keymap.set("n", "<Leader>l", function() toggle_loclist() end, { silent = true, desc = "Toggle location list" })

-- mappings to go back and forth in quick fix & localtion list
utils.create_expr_mapping_family({'n'}, 'q', 'c', 'quickfix list')
utils.create_expr_mapping_family({'n'}, 'l', 'l', 'location list')
