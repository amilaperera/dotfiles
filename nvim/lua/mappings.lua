vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- retaining visual selection
vim.keymap.set('v', '>', '>gv', { silent = true, remap = false, desc = "Shift a visual selection right (retains selection)" })
vim.keymap.set('v', '<', '<gv', { silent = true, remap = false, desc = "Shift a visual selection left (retains selection)" })

-- window resizing
vim.keymap.set('n', '<Up>', '<cmd>resize +1<CR>', { silent = true, desc = "Increases current window height by 1" })
vim.keymap.set('n', '<Down>', '<cmd>resize -1<CR>', { silent = true, desc = "Decreases current window height by 1" })
vim.keymap.set('n', '<Right>', '<cmd>vertical resize +1<CR>', { silent = true , desc = "Increases the current window width by 1"})
vim.keymap.set('n', '<Left>', '<cmd>vertical resize -1<CR>', { silent = true , desc = "Decreases the current window width by 1"})

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
    vim.keymap.set('n', '<Leader>'..i, i..'gt', { silent = true, desc = "Move to tab "..i })
end
vim.keymap.set('n', '<Leader>xt', ":tabclose<CR>", { silent = true, desc = "Closes tab" })

-- Moving visual blocks up and down.
-- multiple lines in visual mode
vim.keymap.set('v', '[e', ":m '<-2<CR>gv=gv", { silent = true, desc = "In visual mode moves selection up" })
vim.keymap.set('v', ']e', ":m '>+1<CR>gv=gv", { silent = true, desc = "In visual mode moves selection down" })
-- current line normal mode
vim.keymap.set('n', '[e', "ddkP", { silent = true, desc = "In normal mode moves the current line up" })
vim.keymap.set('n', ']e', "ddp", { silent = true, desc = "In normal mode moves the current line down" })

-- scroll up and down focussing the center
vim.keymap.set('n', "<C-d>", "<C-d>zz")
vim.keymap.set('n', "<C-u>", "<C-u>zz")

-- open $MYVIMRC in a new tab
vim.keymap.set('n', "<Leader>v", ":tabe $MYVIMRC<CR>")

-- toggles an option
local toggle_option = function(option)
    if vim.opt[option]:get() then
        vim.opt[option] = false
    else
        vim.opt[option] = true
    end
end

-- toggles 2 options
local toggle_options = function(opt1, opt2)
    if vim.opt[opt1]:get() and vim.opt[opt2]:get() then
        vim.opt[opt1], vim.opt[opt2] = false, false
    else
        vim.opt[opt1], vim.opt[opt2] = true, true
    end
end

-- trying to emulate some of Tim Pope's unimpaired toggles
vim.keymap.set('n', "yoc", function() toggle_option('cursorline') end, { silent = true , desc = "Toggle cursor line"})
vim.keymap.set('n', "you", function() toggle_option('cursorcolumn') end, { silent = true, desc = "Toggle cursor column" })
vim.keymap.set('n', "yoh", function() toggle_option('hlsearch') end, { silent = true, desc = "Toggle highlight search" })
vim.keymap.set('n', "yoi", function() toggle_option('ignorecase') end, { silent = true, desc = "Toggle ignorecase" })
vim.keymap.set('n', "yon", function() toggle_option('number') end, { silent = true, desc = "Toggle number" })
vim.keymap.set('n', "yor", function() toggle_option('relativenumber') end, { silent = true, desc = "Toggle relativenumber" })
vim.keymap.set('n', "yos", function() toggle_option('spell') end, { silent = true, desc = "Toggle spell checker" })
vim.keymap.set('n', "yow", function() toggle_option('wrap') end, { silent = true, desc = "Toggle line wrapping" })

vim.keymap.set(
    'n',
    "yox",
    function() toggle_options('cursorline', 'cursorcolumn') end,
    { silent = true, desc = "Toggle both cursoline and cursorcolumn" })

vim.keymap.set(
    'n',
    "yot",
    function()
        -- this overwrites if you have set any value to colorcolumn
        if next(vim.opt.colorcolumn:get()) == nil then
            vim.opt.colorcolumn = "+1"
        else
            vim.opt.colorcolumn = ""
        end
    end,
    { silent = true, desc = "Toggle colorcolumn" })

-- prev/next
vim.keymap.set('n', '[b', ":bprevious<CR>", { silent = true, desc = "Go to previous buffer" })
vim.keymap.set('n', ']b', ":bnext<CR>", { silent = true, desc = "Go to next buffer" })
vim.keymap.set('n', '[t', ":tabprevious<CR>", { silent = true, desc = "Go to previous tab" })
vim.keymap.set('n', ']t', ":tabnext<CR>", { silent = true, desc = "Go to next tab" })
vim.keymap.set('n', '[q', ":cprevious<CR>", { silent = true, desc = "Go to previous item in quickfix window" })
vim.keymap.set('n', ']q', ":cnext<CR>", { silent = true, desc = "Go to next error item in quickfix window" })
vim.keymap.set('n', '[l', ":lprevious<CR>", { silent = true, desc = "Go to previous item in location list" })
vim.keymap.set('n', ']l', ":lnext<CR>", { silent = true, desc = "Go to next item in location list" })

-- quickfix/location list toggling
local is_list_open = function(key)
    local info = vim.fn.getwininfo()
    for _, list in ipairs(info) do
        if list[key] == 1 then
            return true
        end
    end
    return false
end

local toggle_quickfix = function()
    if is_list_open('quickfix') then
        vim.cmd[[cclose]]
    else
        vim.cmd[[cwindow]]
    end
end

local toggle_loclist = function()
    if is_list_open('loclist') then
        vim.cmd[[lclose]]
    else
        vim.cmd[[lwindow]]
    end
end

vim.keymap.set("n", "<Leader>q", function() toggle_quickfix() end, { silent = true, desc = "Toggle quickfix window" })
vim.keymap.set("n", "<Leader>l", function() toggle_loclist() end, { silent = true, desc = "Toggle location list" })

