return {
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            -- disable netrw (recommended)
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1

            require("nvim-tree").setup({
                sort_by = "case_sensitive",

                view = {
                    width = 35,
                    side = "left",
                    preserve_window_proportions = true,
                },

                renderer = {
                    group_empty = true,
                    highlight_git = "all",
                    highlight_opened_files = "name",

                    icons = {
                        show = {
                            file = true,
                            folder = true,
                            folder_arrow = true,
                            git = true,
                        },
                    },
                },

                filters = {
                    dotfiles = false, -- set true if you want to hide .files
                },

                git = {
                    enable = true,
                    ignore = false,
                },

                diagnostics = {
                    enable = false,
                },

                actions = {
                    open_file = {
                        quit_on_open = false, -- keep tree open
                    },
                },

                update_focused_file = {
                    enable = true,
                    update_root = true,
                },
            })

            -- keymap: '\' to toggle
            vim.keymap.set("n", "\\", "<cmd>NvimTreeToggle<CR>", {
                desc = "Toggle NvimTree",
                silent = true,
            })
            -- reveel current file in nvim-tree
            vim.keymap.set("n", "<leader>r", function()
                require("nvim-tree.api").tree.find_file({ open = true, focus = true })
            end, { desc = "Reveal current file in NvimTree" })
        end,
    },
}
