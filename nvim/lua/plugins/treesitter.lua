return {
    {
        'nvim-treesitter/nvim-treesitter',

        build = ':TSUpdate',

        opts = {
            ensure_installed = {
                "bash",
                "c",
                "cmake",
                "cpp",
                "diff",
                "gitattributes",
                "gitcommit",
                "git_rebase",
                "html",
                "lua",
                "make",
                "python",
                "rust",
                "vim",
                "markdown",
            },

            sync_install = false,
            auto_install = true,
            ignore_install = {},

            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            }
        },

        config = function(_, opts)
            require('nvim-treesitter.configs').setup(opts)
        end,
    }
}
