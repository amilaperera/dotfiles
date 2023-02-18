-- check if we can load the module as packer treats this as a conditionally useable plugin
local loaded, _ = pcall(function () require 'telescope' end)
if not loaded then
    return
end

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
local get_git_root = function(dir)
    local cwd = vim.fn.escape(vim.fn.expand(dir), ' ')
    local find_path = cwd .. ';'

    local git_root = vim.fn.finddir('.git', find_path)
    if git_root == '' then -- not a git directory
        return cwd
    end
    return vim.fn.fnamemodify(git_root, ':p:h:h')
end

local git_root_of_current_buffer = function()
    return get_git_root('%:p:h')
end

local is_git_directory = function(dir)
    local cwd = vim.fn.escape(vim.fn.expand(dir), ' ')
    local find_path = cwd .. ';'
    return vim.fn.finddir('.git', find_path) ~= ''
end

-- explore a directory
local explore = function(opts)
    -- changed to directory
    if vim.fn.chdir(opts.dir) == '' then
        print("Can't find directory " .. opts.dir)
    else
        local builtin = require("telescope.builtin")
        if is_git_directory(opts.dir) then
            builtin.git_files({cwd = opts.dir})
        else
            builtin.find_files({cwd = opts.dir})
        end
    end
end

local builtin = require("telescope.builtin")
-- keymaps
vim.keymap.set('n', 'T', '<cmd>Telescope<CR>', {})
vim.keymap.set('n', '<leader>f', builtin.find_files, {})
vim.keymap.set('n', '<C-t>', builtin.git_files, {})
vim.keymap.set('n', '<leader>c', builtin.git_commits, {})
vim.keymap.set('n', '<leader>b', builtin.buffers, {})
vim.keymap.set('n', '<leader>m', builtin.oldfiles, {})

-- project live grep
vim.keymap.set('n', '<leader>pl', function()
        local root = git_root_of_current_buffer()
        builtin.live_grep({cwd = root})
    end, {})

-- project live grep (case insensitive)
vim.keymap.set('n', '<leader>ipl', function()
        local root = git_root_of_current_buffer()
        builtin.live_grep({cwd = root, additional_args = {"-i"}})
    end, {})

-- project search (Handy alternative to C-R C-W to search the exact word)
vim.keymap.set('n', '<leader>ps', function()
    local root = git_root_of_current_buffer()
    builtin.grep_string({cwd = root, search = vim.fn.input("Grep > ") })
end)

-- explore configs
vim.keymap.set('n', '<leader>ec', function() explore({dir = "~/.dotfiles"}) end)

-- explore plugins' directory
vim.keymap.set('n', '<leader>ep', function() explore({dir = "~/.local/share/nvim/site/pack/packer/start"}) end)

-- Awesome fzf algorithm with telescope
require('telescope').load_extension('fzf')
