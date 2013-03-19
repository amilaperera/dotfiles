return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        version = "*",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
        },
        lazy = false,
        keys = {
            { "\\", ":Neotree reveal<CR>", desc = "NeoTree reveal", silent = true },
        },
        ---@module 'neo-tree'
        ---@type neotree.Config
        opts = {
            filesystem = {
                window = {
                    mappings = {
                        ["\\"] = "close_window",
                    },
                },
            },
        },
    },
}
