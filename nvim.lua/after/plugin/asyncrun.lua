-- automatically open quickfix window when the command starts at 15 lines height
vim.cmd([[let g:asyncrun_open = 15]])

vim.api.nvim_create_augroup("BuildGroup", { clear = true})
vim.api.nvim_create_autocmd({"FileType"}, {
    pattern = {"cpp", "c", "cmake"},
    callback = function()
        vim.api.nvim_buf_create_user_command(0, 'BuildGcc', "AsyncRun -cwd=$(VIM_ROOT)/build.gcc ninja -j8", {})
        vim.api.nvim_buf_create_user_command(0, 'BuildGccRel', "AsyncRun -cwd=$(VIM_ROOT)/build.gcc.rel ninja -j8", {})
        vim.api.nvim_buf_create_user_command(0, 'BuildClang', "AsyncRun -cwd=$(VIM_ROOT)/build.clang ninja -j8", {})
        vim.api.nvim_buf_create_user_command(0, 'BuildClangRel', "AsyncRun -cwd=$(VIM_ROOT)/build.clang.rel ninja -j8", {})
    end,
    group = "BuildGroup"
})
