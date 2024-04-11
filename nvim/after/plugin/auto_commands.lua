-- easily close temporary buffer windows like help, fugitive etc.
local fast_close_group = vim.api.nvim_create_augroup("FastCloseGroup", { clear = true })
vim.api.nvim_create_autocmd({"FileType"}, {
    pattern = {"help", "fugitive", "fugitiveblame", "git", "gitcommit"},
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
        vim.keymap.set('n', '<Leader><Space>', ":w<CR>:source %<CR>", { buffer = true })
    end,
    group = source_files_group
})

-- Toggle cursorline on only if,
--  buffer window active
--  not in insert mode
local cursor_group = vim.api.nvim_create_augroup("CursorGroup", { clear = true })
vim.api.nvim_create_autocmd({"InsertEnter", "WinLeave", "BufLeave"}, {
    pattern = {"*"},
    callback = function ()
        vim.api.nvim_exec([[setlocal nocursorline]], false)
    end,
    group = cursor_group
})

vim.api.nvim_create_autocmd({"InsertLeave", "WinEnter", "BufEnter"}, {
    pattern = {"*"},
    callback = function ()
        vim.api.nvim_exec([[setlocal cursorline]], false)
    end,
    group = cursor_group
})

-- Highlight on yank
local yank_group = vim.api.nvim_create_augroup("YankGropu", { clear = true })
vim.api.nvim_create_autocmd({"TextYankPost"}, {
    pattern = {"*"},
    command = "silent! lua vim.highlight.on_yank {on_visual=true, timeout=100}",
    group = yank_group
})

-- Command-line window
local commandline_window_group = vim.api.nvim_create_augroup("CommandLineWindowGroup", { clear = true })
vim.api.nvim_create_autocmd({"CmdwinEnter"}, {
    pattern = {"*"},
    callback = function ()
        vim.api.nvim_exec([[setlocal nornu | setlocal nu]], false)
        vim.keymap.set('n', 'q', '<cmd>close<CR>', { silent = true, buffer = true })
    end,
    group = commandline_window_group
})
