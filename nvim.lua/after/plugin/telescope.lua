-- check if we can load the module as packer treats this as a conditionally useable plugin
local loaded, _ = pcall(function () require 'telescope' end)
if not loaded then
    return
end

require('telescope').setup {
    defaults = {
        layout_strategy = 'vertical',
        layout_config = { height = 0.95, width = 0.9 },
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

    -- This is the general case i.e. .git is likely to be directory
    local git_root = vim.fn.finddir('.git', find_path)
    if git_root ~= '' then
        return vim.fn.fnamemodify(git_root, ':p:h:h')
    end

    -- Or else it may be a regular file
    git_root = vim.fn.findfile('.git', find_path)
    if git_root ~= '' then
        return vim.fn.fnamemodify(git_root, ':p:h')
    end

    -- Nothing found, simply return current working directory
    return cwd
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
vim.keymap.set('n', 'T', '<cmd>Telescope<CR>', {desc = 'Invoke telescope'})
vim.keymap.set('n', '<leader><Space>', builtin.git_files, {desc = ''})
vim.keymap.set('n', '<leader>?', builtin.oldfiles, {desc = '[?] Find recentlyl opened files'})
vim.keymap.set('n', '<leader>,', builtin.buffers, {desc = '[,] Find existing buffers'})
vim.keymap.set('n', '<leader>/', builtin.current_buffer_fuzzy_find, {desc = '[/] Fuzzily search current buffer'})

vim.keymap.set('n', '<leader>sf', builtin.find_files, {desc = '[S]earch [F]iles'})
vim.keymap.set('n', '<leader>sh', builtin.help_tags, {desc = '[S]earch [H]elp'})
vim.keymap.set('n', '<leader>sc', builtin.git_commits, {desc = '[S]earch git [C]ommits'})

-- Search by grep (Really handy if you use C-R C-W to search the word under cursor)
vim.keymap.set('n', '<leader>sg', function()
    local root = git_root_of_current_buffer()
    builtin.grep_string({cwd = root, search = vim.fn.input("Grep > ") })
end, {desc = '[S]earch by [G]rep'})

-- project live grep
vim.keymap.set('n', '<leader>sps', function()
    local root = git_root_of_current_buffer()
    builtin.live_grep({cwd = root})
end, {desc = '[S]earch [P]roject (case [S]ensitive)'})

-- project live grep (case insensitive)
vim.keymap.set('n', '<leader>spi', function()
    local root = git_root_of_current_buffer()
    builtin.live_grep({cwd = root, additional_args = {"-i"}})
end, {desc = '[S]earch [P]roject (case [I]nsensitive)'})


-- explore configs
vim.keymap.set('n', '<leader>xc', function() explore({dir = "~/.dotfiles"}) end)

-- explore plugins' directory
vim.keymap.set('n', '<leader>xp', function() explore({dir = "~/.local/share/nvim/site/pack/packer/start"}) end)

-- Awesome fzf algorithm with telescope
require('telescope').load_extension('fzf')
