-- easily close temporary buffer windows like help, fugitive etc.
local fast_close_group = vim.api.nvim_create_augroup("FastCloseGroup", { clear = true })
vim.api.nvim_create_autocmd({"FileType"}, {
    pattern = {"help", "fugitive", "fugitiveblame"},
    callback = function()
        vim.keymap.set('n', 'q', '<cmd>close<CR>', { silent = true, buffer = true })
    end,
    group = fast_close_group
})

-- save and source file
local source_files_group = vim.api.nvim_create_augroup("SourceFilesGroup", { clear = true })
vim.api.nvim_create_autocmd({"FileType"}, {
    pattern = {"lua", "vim"},
    callback = function()
        vim.keymap.set('n', '<leader>x', ":w<CR>:source %<CR>", { buffer = true })
    end,
    group = source_files_group
})

-- colorcolumn for filetypes where I would like to preserve textwidth.
-- Looks a bit visually distracting, therefore for the timebeing I'm going to leave it off.
-- One alternative is to use "yot" from unimpaired to toggle it whenever you need
--[[
local cc_group = vim.api.nvim_create_augroup("CcGroup", { clear = true })
vim.api.nvim_create_autocmd({"FileType"}, {
    pattern = {"c", "cpp", "lua", "python", "sh", "bash"},
    command = "setlocal colorcolumn=+1",
    group = cc_group
})
--]]

-- Toggle cursorline on only if,
--  buffer window active
--  not in insert mode
local cursor_group = vim.api.nvim_create_augroup("CursorGroup", { clear = true })
vim.api.nvim_create_autocmd({"InsertEnter", "WinLeave"}, {
    pattern = {"*"},
    command = "setlocal nocursorline",
    group = cursor_group
})

vim.api.nvim_create_autocmd({"InsertLeave", "WinEnter"}, {
    pattern = {"*"},
    command = "setlocal cursorline",
    group = cursor_group
})

-- Highlight on yank
local yank_group = vim.api.nvim_create_augroup("YankGropu", { clear = true })
vim.api.nvim_create_autocmd({"TextYankPost"}, {
    pattern = {"*"},
    command = "silent! lua vim.highlight.on_yank {on_visual=true, timeout=100}",
    group = yank_group
})
