return {
    {
        "skywind3000/asyncrun.vim",
        enter = "VimEnter",
        config = function()
            -- automatically open quickfix window when the command starts at 15 lines height
            vim.cmd([[let g:asyncrun_open = 15]])

            vim.api.nvim_create_augroup("BuildGroup", { clear = true })
            vim.api.nvim_create_autocmd({ "FileType" }, {
                pattern = { "cpp", "c", "cmake" },
                callback = function()
                    vim.api.nvim_buf_create_user_command(0, "BuildGcc", function(opts)
                        local targets = opts.args or ""
                        vim.fn.execute("AsyncRun ~/.local/build_wrapper.sh <root> gcc debug " .. targets)
                    end, { nargs = "?" })

                    vim.api.nvim_buf_create_user_command(0, "BuildGccRel", function(opts)
                        local targets = opts.args or ""
                        vim.fn.execute("AsyncRun ~/.local/build_wrapper.sh <root> gcc rel " .. targets)
                    end, { nargs = "?" })

                    vim.api.nvim_buf_create_user_command(0, "BuildClang", function(opts)
                        local targets = opts.args or ""
                        vim.fn.execute("AsyncRun ~/.local/build_wrapper.sh <root> clang debug " .. targets)
                    end, { nargs = "?" })

                    vim.api.nvim_buf_create_user_command(0, "BuildClangRel", function(opts)
                        local targets = opts.args or ""
                        vim.fn.execute("AsyncRun ~/.local/build_wrapper.sh <root> clang rel " .. targets)
                    end, { nargs = "?" })
                end,
                group = "BuildGroup",
            })
        end,
    },
}
