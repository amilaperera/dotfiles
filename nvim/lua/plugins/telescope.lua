return {
    {
        "nvim-telescope/telescope.nvim",
        event = "VimEnter",
        dependencies = {
            { "nvim-lua/plenary.nvim" },
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                cond = function()
                    return vim.fn.executable("make") == 1
                end,
            },
            { "nvim-telescope/telescope-ui-select.nvim" },
        },
        config = function()
            require("telescope").setup({
                defaults = {
                    layout_strategy = "vertical",
                    layout_config = { height = 0.95, width = 0.9 },
                },
                pickers = {
                    buffers = {
                        show_all_buffers = true,
                        mappings = {
                            i = {
                                ["<c-d>"] = "delete_buffer",
                            },
                        },
                    },
                },
            })

            -- Enable Telescope extensions if they are installed
            pcall(require("telescope").load_extension, "fzf")
            pcall(require("telescope").load_extension, "ui-select")

            -- retrieve the git root (no system calls i.e. git rev-parse)
            local get_git_root = function(dir)
                local cwd = vim.fn.escape(vim.fn.expand(dir), " ")
                local find_path = cwd .. ";"

                -- This is the general case i.e. .git is likely to be directory
                local git_root = vim.fn.finddir(".git", find_path)
                if git_root ~= "" then
                    return true, vim.fn.fnamemodify(git_root, ":p:h:h")
                end

                -- Or else it may be a regular file
                git_root = vim.fn.findfile(".git", find_path)
                if git_root ~= "" then
                    return true, vim.fn.fnamemodify(git_root, ":p:h")
                end

                -- Nothing found, simply return current working directory
                return false, cwd
            end

            local git_root_of_current_buffer = function()
                local flag, git_root = get_git_root("%:p:h")
                if flag == false then
                    error(git_root .. " is not a git directory.")
                end
                return git_root
            end

            local is_git_directory = function(dir)
                local flag, _ = get_git_root(dir)
                return flag
            end

            -- explore a directory
            local explore = function(opts)
                -- changed to directory
                if vim.fn.chdir(opts.dir) == "" then
                    print("Can't find directory " .. opts.dir)
                else
                    local builtin = require("telescope.builtin")
                    if is_git_directory(opts.dir) then
                        builtin.git_files({ cwd = opts.dir })
                    else
                        builtin.find_files({ cwd = opts.dir })
                    end
                end
            end

            local builtin = require("telescope.builtin")
            -- keymaps
            vim.keymap.set("n", "T", "<cmd>Telescope<CR>", { desc = "Invoke telescope" })
            vim.keymap.set("n", "<C-T>", builtin.git_files, { desc = "Telescope inside git directory" })
            vim.keymap.set("n", "<Leader>R", builtin.resume, { desc = "Telescope resume" })
            vim.keymap.set("n", "<Leader>?", builtin.oldfiles, { desc = "[?] Find recently opened files" })
            vim.keymap.set("n", "<Leader><Leader>", builtin.buffers, { desc = "[<Leader>] Find existing buffers" })
            vim.keymap.set(
                "n",
                "<Leader>/",
                builtin.current_buffer_fuzzy_find,
                { desc = "[/] Fuzzily search current buffer" }
            )

            vim.keymap.set("n", "<Leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
            vim.keymap.set("n", "<Leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
            vim.keymap.set("n", "<Leader>sc", builtin.git_commits, { desc = "[S]earch git [C]ommits" })
            -- helpful for checking out a new branch when you're inside Neovim
            vim.keymap.set("n", "<Leader>sb", builtin.git_branches, { desc = "[S]earch git [B]ranches" })

            -- Search by grep (Really handy if you use C-R C-W to search the word under cursor)
            vim.keymap.set("n", "<Leader>sg", function()
                local root = git_root_of_current_buffer()
                builtin.grep_string({ cwd = root, search = vim.fn.input("Grep > ") })
            end, { desc = "[S]earch by [G]rep" })

            -- search project
            -- Handle case sensitivity with smartcase
            vim.keymap.set("n", "<Leader>sp", function()
                local root = git_root_of_current_buffer()
                builtin.live_grep({ cwd = root })
            end, { desc = "[S]earch [P]roject" })

            -- explore configs
            vim.keymap.set("n", "<Leader>xc", function()
                explore({ dir = "~/.dotfiles" })
            end)

            -- explore plugins' directory
            vim.keymap.set("n", "<Leader>xp", function()
                explore({ dir = "~/.local/share/nvim/lazy" })
            end)
        end,
    },
}
