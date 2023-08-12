vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- retaining visual selection
vim.keymap.set('v', '>', '>gv', { silent = true, remap = false })
vim.keymap.set('v', '<', '<gv', { silent = true, remap = false })

-- window resizing
vim.keymap.set('n', '<Up>', '<cmd>resize +1<CR>', { silent = true })
vim.keymap.set('n', '<Down>', '<cmd>resize -1<CR>', { silent = true })
vim.keymap.set('n', '<Left>', '<cmd>vertical resize -1<CR>', { silent = true })
vim.keymap.set('n', '<Right>', '<cmd>vertical resize +1<CR>', { silent = true })

-- change to the directory of the current buffer
vim.keymap.set('n', 'cd', function()
    vim.fn.chdir(vim.fn.expand('%:p:h'))
    print("Changed to: " .. vim.fn.getcwd())
end)
-- change to git directory
vim.keymap.set('n', 'gcd', function()
    vim.cmd([[Gcd]])
    print("Changed to: " .. vim.fn.getcwd())
end)

-- switching tabs made easy
for i = 1,9 do
    vim.keymap.set('n', '<Leader>'..i, i..'gt')
end
vim.keymap.set('n', '<C-Left>', ":tabprevious<CR>")
vim.keymap.set('n', '<C-Right>', ":tabnext<CR>")
vim.keymap.set('n', '<Leader>xt', ":tabclose<CR>")

-- Moving visual blocks up and down.
-- multiple lines in visual mode
vim.keymap.set('v', ']e', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', '[e', ":m '<-2<CR>gv=gv")
-- current line normal mode
vim.keymap.set('n', ']e', "ddp")
vim.keymap.set('n', '[e', "ddkP")

-- scroll up and down focussing the center
vim.keymap.set('n', "<C-d>", "<C-d>zz")
vim.keymap.set('n', "<C-u>", "<C-u>zz")

-- open $MYVIMRC in a new tab
vim.keymap.set('n', "<Leader>v", ":tabe $MYVIMRC<CR>")

-- File full path. If you're unhappy with Ctrl_G output
vim.keymap.set('n', "<Space>", function() print(vim.fn.expand('%:p')) end, { silent = true })

local toggle_option = function(option)
    if vim.opt[option]:get() then
        vim.opt[option] = false
    else
        vim.opt[option] = true
    end
end

local toggle_cursor_options = function(opt1, opt2)
    if vim.opt[opt1]:get() and vim.opt[opt2]:get() then
        vim.opt[opt1] = false
        vim.opt[opt2] = false
    else
        vim.opt[opt1] = true
        vim.opt[opt2] = true
    end
end

-- trying to emulate some of Tim Pope's unimpaired toggles
vim.keymap.set('n', "yoc", function() toggle_option('cursorline') end, { silent = true })
vim.keymap.set('n', "you", function() toggle_option('cursorcolumn') end, { silent = true })
vim.keymap.set('n', "yoh", function() toggle_option('hlsearch') end, { silent = true })
vim.keymap.set('n', "yoi", function() toggle_option('ignorecase') end, { silent = true })
vim.keymap.set('n', "yon", function() toggle_option('number') end, { silent = true })
vim.keymap.set('n', "yor", function() toggle_option('relativenumber') end, { silent = true})
vim.keymap.set('n', "yos", function() toggle_option('spell') end, { silent = true })
vim.keymap.set('n', "yow", function() toggle_option('wrap') end, { silent = true })

vim.keymap.set(
    'n',
    "yox",
    function() toggle_cursor_options('cursorline', 'cursorcolumn') end,
    { silent = true })

