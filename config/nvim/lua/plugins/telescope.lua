return {
    {
        "nvim-telescope/telescope.nvim",
        -- By default, Telescope is included and acts as your picker for everything.

        -- If you would like to switch to a different picker (like snacks, or fzf-lua)
        -- you can disable the Telescope plugin by setting enabled to false and enable
        -- your replacement picker by requiring it explicitly (e.g. 'custom.plugins.snacks')

        -- Note: If you customize your config for yourself,
        -- it’s best to remove the Telescope plugin config entirely
        -- instead of just disabling it here, to keep your config clean.
        enabled = true,
        event = "VimEnter",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { -- If encountering errors, see telescope-fzf-native README for installation instructions
                "nvim-telescope/telescope-fzf-native.nvim",

                -- `build` is used to run some command when the plugin is installed/updated.
                -- This is only run then, not every time Neovim starts up.
                build = "make",

                -- `cond` is a condition used to determine whether this plugin should be
                -- installed and loaded.
                cond = function()
                    return vim.fn.executable("make") == 1
                end,
            },
            { "nvim-telescope/telescope-ui-select.nvim" },

            -- Useful for getting pretty icons, but requires a Nerd Font.
            { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
        },
        config = function()
            -- Telescope is a fuzzy finder that comes with a lot of different things that
            -- it can fuzzy find! It's more than just a "file finder", it can search
            -- many different aspects of Neovim, your workspace, LSP, and more!
            --
            -- The easiest way to use Telescope, is to start by doing something like:
            --  :Telescope help_tags
            --
            -- After running this command, a window will open up and you're able to
            -- type in the prompt window. You'll see a list of `help_tags` options and
            -- a corresponding preview of the help.
            --
            -- Two important keymaps to use while in Telescope are:
            --  - Insert mode: <c-/>
            --  - Normal mode: ?
            --
            -- This opens a window that shows you all of the keymaps for the current
            -- Telescope picker. This is really useful to discover what Telescope can
            -- do as well as how to actually do it!

            -- [[ Configure Telescope ]]
            -- See `:help telescope` and `:help telescope.setup()`
            require("telescope").setup({
                -- You can put your default mappings / updates / etc. in here
                --  All the info you're looking for is in `:help telescope.setup()`
                --
                -- defaults = {
                --   mappings = {
                --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
                --   },
                -- },
                -- pickers = {}
                extensions = {
                    ["ui-select"] = { require("telescope.themes").get_dropdown() },
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
            vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
            vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
            vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
            vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
            vim.keymap.set({ "n", "v" }, "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
            vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
            vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
            vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
            vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
            vim.keymap.set("n", "<leader>sc", builtin.commands, { desc = "[S]earch [C]ommands" })
            vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

            vim.keymap.set(
                "n",
                "<Leader>/",
                builtin.current_buffer_fuzzy_find,
                { desc = "[/] Fuzzily search current buffer" }
            )

            -- Shortcut for searching your Neovim configuration files
            vim.keymap.set("n", "<leader>sn", function()
                builtin.find_files({ cwd = vim.fn.stdpath("config") })
            end, { desc = "[S]earch [N]eovim files" })

            -- If you're inside a git directory, you can use the following mappings
            vim.keymap.set("n", "<leader><CR>", builtin.git_files, { desc = "Telescope inside git directory" })
            -- Grep project. Handle case sensitivity with smartcase
            vim.keymap.set("n", "<leader>sp", function()
                local root = git_root_of_current_buffer()
                builtin.live_grep({ cwd = root })
            end, { desc = "[S]earch [P]roject" })
            -- git commits
            vim.keymap.set("n", "<leader>si", builtin.git_commits, { desc = "[S]earch git Comm[i]ts" })
            -- helpful for checking out a new branch when you're inside Neovim
            vim.keymap.set("n", "<leader>sb", builtin.git_branches, { desc = "[S]earch git [B]ranches" })
        end,
    },
}
