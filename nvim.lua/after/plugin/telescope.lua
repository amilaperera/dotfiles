require('telescope').setup {
    defaults = {
        layout_strategy = 'vertical',
        layout_config = { height = 0.95, width = 0.7 },
    },
    pickers = {
        find_files = {
            -- theme = "dropdown"
        },
        git_files = {
            -- theme = "dropdown"
        },
        git_commits = {
            git_command = {"git", "log", "--pretty=oneline", "--abbrev-commit"},
            -- theme = "dropdown"
        },
        buffers = {
            -- theme = "dropdown"
        },
        old_files = {
            -- theme = "dropdown"
        },
        live_grep = {
            -- theme = "dropdown"
        },
    }
}

local builtin = require("telescope.builtin")
-- builtin.git_commits({git_command = {"git", "log", "--pretty=oneline", "--abbrev-commit"}})

vim.keymap.set('n', '<leader>f', builtin.find_files, {})
vim.keymap.set('n', '<C-t>', builtin.git_files, {})
vim.keymap.set('n', '<leader>c', builtin.git_commits, {})
vim.keymap.set('n', '<leader>b', builtin.buffers, {})
vim.keymap.set('n', '<leader>m', builtin.oldfiles, {})
vim.keymap.set('n', '<leader>pl', builtin.live_grep, {})
vim.keymap.set('n', '<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
