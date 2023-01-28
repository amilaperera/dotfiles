vim.g.mapleader = ","

-- reatin visual selection
vim.keymap.set('v', '>', '>gv', { silent = true, remap = false})
vim.keymap.set('v', '<', '<gv', { silent = true, remap = false})

-- window resizing
vim.keymap.set('n', '<Up>', '<cmd>resize +1<CR>', { silent = true })
vim.keymap.set('n', '<Down>', '<cmd>resize -1<CR>', { silent = true })
vim.keymap.set('n', '<Left>', '<cmd>vertical resize -1<CR>', { silent = true })
vim.keymap.set('n', '<Right>', '<cmd>vertical resize +1<CR>', { silent = true })

-- get the full path of the file in the current buffer
vim.keymap.set('n', '<Leader><Space>', function()
  print(vim.fn.expand('%:p'))
end)
-- change to the directory of the current buffer
vim.keymap.set('n', 'cd', function()
  vim.cmd([[cd %:p:h]])
  print(vim.cmd[[pwd]])
end)

-- switching tabs made easy
vim.keymap.set('n', '<Leader>1', '1gt')
vim.keymap.set('n', '<Leader>2', '2gt')
vim.keymap.set('n', '<Leader>3', '3gt')
vim.keymap.set('n', '<Leader>4', '4gt')
vim.keymap.set('n', '<Leader>5', '5gt')
vim.keymap.set('n', '<Leader>6', '6gt')
vim.keymap.set('n', '<Leader>7', '7gt')
vim.keymap.set('n', '<Leader>8', '8gt')
vim.keymap.set('n', '<Leader>9', '9gt')

-- moving visual blocks up and down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- scroll up and down focussing the center
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- retaining current search always at the center
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
