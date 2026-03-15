return {
    {
        "sindrets/diffview.nvim",
        dependencies = {
            { "nvim-tree/nvim-web-devicons" },
        },
        config = function()
            require("diffview").setup({
                diff_binaries = false,
                enhanced_diff_hl = true,
                -- file history
                vim.keymap.set("n", "<Leader>fh", "<cmd>DiffviewFileHistory %<CR>"),
                vim.keymap.set("n", "<Leader>do", "<cmd>DiffviewOpen<CR>"),
                vim.keymap.set("n", "<Leader>dc", "<cmd>DiffviewClose<CR>"),
            })
        end,
    },
}
