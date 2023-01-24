require('telescope').setup {
  defaults = {},
  pickers = {
    find_files = {
      theme = "dropdown"
    },
    git_files = {
      theme = "dropdown"
    },
    git_commits = {
      theme = "dropdown"
    },
    buffers = {
      theme = "dropdown"
    },
    old_files = {
      theme = "dropdown"
    },
    live_grep = {
      theme = "dropdown"
    },
  }
}

local builtin = require("telescope.builtin")
vim.keymap.set('n', '<leader>f', builtin.find_files, {})
vim.keymap.set('n', '<C-t>', builtin.git_files, {})
vim.keymap.set('n', '<leader>c', builtin.git_commits, {})
vim.keymap.set('n', '<leader>b', builtin.buffers, {})
vim.keymap.set('n', '<leader>m', builtin.oldfiles, {})
vim.keymap.set('n', '<leader>g', builtin.live_grep, {})
vim.keymap.set('n', '<leader>ps', function()
  builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
