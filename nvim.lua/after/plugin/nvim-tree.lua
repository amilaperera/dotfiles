-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- Setup with some options
-- Desperately trying to bring NvimTree closer to plain old (but yet good) NerdTree
require("nvim-tree").setup({
  renderer = {
    icons = {
      show = {
        git = true,
	file = false,
	folder = false,
	folder_arrow = true,
      },
      glyphs = {
        folder = {
          arrow_closed = "⏵",
          arrow_open = "⏷",
        },
        git = {
          unstaged = "✗",
          staged = "✓",
          unmerged = "⌥",
          renamed = "➜",
          untracked = "★",
          deleted = "⊖",
          ignored = "◌",
        },
      },
    },
  },
})

-- open/close
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>')
-- reveal file
vim.keymap.set('n', '<leader>r', ':NvimTreeFindFile<CR>')

