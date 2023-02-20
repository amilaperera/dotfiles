vim.g.mapleader = ","

-- reatin visual selection
vim.keymap.set('v', '>', '>gv', { silent = true, remap = false })
vim.keymap.set('v', '<', '<gv', { silent = true, remap = false })

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
    vim.fn.chdir(vim.fn.expand('%:p:h'))
    print("Changed to: " .. vim.fn.getcwd())
end)

-- switching tabs made easy
for i = 1,9 do
    vim.keymap.set('n', '<Leader>'..i, i..'gt')
end

-- moving visual blocks up and down
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

-- scroll up and down focussing the center
vim.keymap.set('n', "<C-d>", "<C-d>zz")
vim.keymap.set('n', "<C-u>", "<C-u>zz")

-- open $MYVIMRC in a new tab
vim.keymap.set('n', "<Leader>v", ":tabe $MYVIMRC<CR>")
