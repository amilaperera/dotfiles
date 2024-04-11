local utils = require('common')

vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- retaining visual selection
vim.keymap.set('v', '>', '>gv', { silent = true, remap = false, desc = "Shift a visual selection right (retains selection)" })
vim.keymap.set('v', '<', '<gv', { silent = true, remap = false, desc = "Shift a visual selection left (retains selection)" })

-- window resizing
vim.keymap.set(
    'n',
    '<Up>',
    function() return '<cmd>resize +' .. vim.v.count1 .. '<CR>' end,
    { expr = true, silent = true, desc = "Increases current window height by a count" })
vim.keymap.set(
    'n',
    '<Down>',
    function() return '<cmd>resize -' .. vim.v.count1 .. '<CR>' end,
    { expr = true, silent = true, desc = "Decreases current window height by a count" })
vim.keymap.set(
    'n',
    '<Right>',
    function() return '<cmd>vertical resize +' .. vim.v.count1 .. '<CR>' end,
    { expr = true, silent = true , desc = "Increases the current window width by a count"})
vim.keymap.set(
    'n',
    '<Left>',
    function() return '<cmd>vertical resize -' .. vim.v.count1 .. '<CR>' end,
    { expr = true, silent = true , desc = "Decreases the current window width by a count"})

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
function move_visual_up(count)
    vim.api.nvim_exec("'<,'>move'<--" .. count, false)
    vim.api.nvim_command("normal! gv")
end

function move_visual_down(count)
    vim.api.nvim_exec("'<,'>move'>+" .. count, false)
    vim.api.nvim_command("normal! gv")
end

vim.api.nvim_set_keymap(
    'x',
    '[e',
    ":lua move_visual_up(vim.v.count1)<CR>",
    { noremap = true, silent = true, desc = "In visual mode moves the current [count] lines up" })

vim.api.nvim_set_keymap(
    'x',
    ']e',
    ":lua move_visual_down(vim.v.count1)<CR>",
    { noremap = true, silent = true, desc = "In visual mode moves the current [count] lines down" })

-- current line normal mode (count supported)
vim.keymap.set(
    'n',
    '[e',
    function() vim.fn.execute("normal dd" .. vim.v.count1 .. "kP") end,
    { silent = true, desc = "In normal mode moves the current [count] line(s) up" })

vim.keymap.set(
    'n',
    ']e',
    function() vim.fn.execute("normal dd" .. (vim.v.count1) .. "jP") end,
    { silent = true, desc = "In normal mode moves the current [count] line(s) down" })

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
        -- this overwrites any value you have set for colorcolumn
        if next(vim.opt.colorcolumn:get()) == nil then
            vim.opt.colorcolumn = {"+1"}
        else
            vim.opt.colorcolumn = {}
        end
    end,
    { silent = true, desc = "Toggle colorcolumn=+1 or none" })

-- prev/next tab with a count
vim.keymap.set(
    'n',
    '[t',
    function()
        vim.fn.execute('normal ' .. vim.v.count1 .. 'gT')
    end,
    { silent = true, desc = "Go to the [count] previous tab" })

vim.keymap.set(
    'n',
    ']t',
    function()
        for i = 1, vim.v.count1 do
            vim.fn.execute('normal gt')
        end
    end,
    { silent = true, desc = "Go to the [count] next tab" })

utils.create_expr_mapping_family({'n'}, 'b', 'b', 'buffer')

-- Insert blank lines while you're in nomral mode.
-- Cursor line stays unchanged.
local insert_blanks = function(n, after)
    local blanks = {}
    for i = 1, n do
        blanks[i] = ""
    end
    vim.api.nvim_put(blanks, 'l', after, false)
end

vim.keymap.set(
    'n',
    '[<Space>',
    function()
        insert_blanks(vim.v.count1, false)
        vim.fn.execute('normal ' .. vim.v.count1 .. 'j')
    end,
    { silent = true, desc = "Insert empty [count] line(s) before the current line" })

vim.keymap.set(
    'n',
    ']<Space>',
    function()
        insert_blanks(vim.v.count1, true)
        vim.fn.execute('normal k')
    end,
    { silent = true, desc = "Insert empty [count] line(s) after the current line" })

local toggle_window_zoom = function()
    if vim.t.window_restore_command == nil then
        vim.t.window_restore_command = vim.fn.winrestcmd()
        vim.cmd[[vertical resize | resize]]
    else
        vim.fn.execute(vim.t.window_restore_command)
        vim.t.window_restore_command = nil
    end
end

-- Window zoom toggle
-- TODO: Add the window zoom status to status bar
vim.keymap.set("n", "yoz", function() toggle_window_zoom() end, { silent = false, desc = "Toggle window zooming" })

-- Git status information.
-- This could also go in the statusline, but somewhat expensive.
-- NOTE: Relies on gitsigns
vim.keymap.set(
    "n",
    "<C-h>",
    function()
        local info = vim.b.gitsigns_status_dict
        local info_str = ''
        if info ~= nil then
            info_str = table.concat({info.head, ' | +', info.added, ' -', info.removed, ' ~', info.changed})
        end
        print(info_str)
    end,
    { silent = true, desc = "Git status on the buffer"})

vim.keymap.set(
    'n',
    "<Leader>gr",
    function()
        local header = ':grep -irE "'
        -- This is used to move the cursor position so that user can start typing the search pattern.
        -- FIXME: May be a better way exists ? API ?
        local cursor_moves = '<C-b>'
        for _ = 2, #header do
            cursor_moves = cursor_moves .. "<Right>"
        end
        return header .. '" '  .. vim.fn.expand('%:p:h') .. cursor_moves
    end,
    { expr = true, desc = "Use grep in a native way in the current directory" })
