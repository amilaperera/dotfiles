return {
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",
        branch = "main",
        -- [[ Configure Treesitter ]] See `:help nvim-treesitter-intro`
        opts = {
            ensure_installed = {
                "bash",
                "c",
                "cpp",
                "cmake",
                "diff",
                "html",
                "lua",
                "luadoc",
                "markdown",
                "markdown_inline",
                "python",
                "query",
                "tmux",
                "vim",
                "vimdoc",
            },
            sync_install = false,
            auto_install = true,
            highlight = { enable = true },
            indent = { enable = true },
        },
    },
}
