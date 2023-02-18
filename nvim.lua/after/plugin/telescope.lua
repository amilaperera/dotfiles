require('telescope').setup {
    defaults = {
        layout_strategy = 'vertical',
        layout_config = { height = 0.95, width = 0.7 },
    },
    pickers = {
        git_commits = {
            -- The command is the default used by the plugin itself,
            -- but Fedora 37 had some issues without me providing it here for some reason (probably a combination of git +
            -- telescope caused this issue)
            git_command = {"git", "log", "--pretty=oneline", "--abbrev-commit"},
        },
    }
}

-- retrieve the git root (no system calls i.e. git rev-parse)
local get_git_root = function()
    local cwd = vim.fn.escape(vim.fn.expand('%:p:h'), ' ')
    local find_path = cwd .. ';'

    local git_root = vim.fn.finddir('.git', find_path)
    if git_root == '' then -- not a git directory
        return cwd
    end
    return vim.fn.fnamemodify(git_root, ':p:h:h')
end

-- explore a directory
local explore = function(opts)
    if vim.fn.chdir(opts.dir) == '' then
        print("Can't find" .. opts.dir)
    else
        local builtin = require("telescope.builtin")

        opts.git = opts.git or false
        if opts.git then
            builtin.git_files({cwd = opts.dir})
        else
            builtin.find_files({cwd = opts.dir})
        end
    end
end

local builtin = require("telescope.builtin")
-- keymaps
vim.keymap.set('n', '<leader>f', builtin.find_files, {})
vim.keymap.set('n', '<C-t>', builtin.git_files, {})
vim.keymap.set('n', '<leader>c', builtin.git_commits, {})
vim.keymap.set('n', '<leader>b', builtin.buffers, {})
vim.keymap.set('n', '<leader>m', builtin.oldfiles, {})

-- project live grep
vim.keymap.set('n', '<leader>pl', function()
        local root = get_git_root()
        builtin.live_grep({cwd = root})
    end, {})

-- project live grep (case insensitive)
vim.keymap.set('n', '<leader>ipl', function()
        local root = get_git_root()
        builtin.live_grep({cwd = root, additional_args = {"-i"}})
    end, {})

-- project search (Handy alternative to C-R C-W to search the exact word)
vim.keymap.set('n', '<leader>ps', function()
    local root = get_git_root()
    builtin.grep_string({cwd = root, search = vim.fn.input("Grep > ") })
end)

-- explore configs
vim.keymap.set('n', '<leader>ec', function() explore({dir = "~/.dotfiles", git = true}) end)

-- explore plugins' directory
vim.keymap.set('n', '<leader>ep', function() explore({dir = "~/.local/share/nvim/site/pack/packer/start"}) end)

-- Awesome fzf algorithm with telescope
require('telescope').load_extension('fzf')
