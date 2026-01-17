local o = vim.opt

-- no cursor styling
o.guicursor = ""

-- This can be overriden on filetype
o.tabstop = 4
o.softtabstop = 4
o.shiftwidth = 4
-- always insert spaces
o.expandtab = true

o.smartindent = true

-- set highlight on search
o.hlsearch = true
o.incsearch = true
-- preview substitutions on a separate split
o.inccommand = "split"
-- case insensitive searches unless, \C or one or more capital letters in the search
o.ignorecase = true
o.smartcase = true

-- save undo history
o.undofile = true

-- enable mouse mode only in normal and visual mode
o.mouse = "nv"

o.number = true
o.relativenumber = true

o.cursorline = true

o.swapfile = false
o.updatetime = 250

o.foldenable = false

o.wildignorecase = true

o.spelllang = "en"
o.spell = false

o.textwidth = 120
o.formatoptions:append("t")

-- Configure how new splits should be opened
o.splitright = true
o.splitbelow = true

-- It's (somewhat) annoying to see '<20>' all the time when a keymap with the leader (assuming your leader is <Space>)
-- is about to be triggered.
-- Having said that, setting this to 'false' takes other useful information such as the number of visually selected characters etc.
o.showcmd = true

-- screen lines to keep above and below the cursor
o.scrolloff = 5

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Filetype configurations
-- Treat .ipp and .tpp files as C++
vim.filetype.add({
    extension = {
        ipp = "cpp",
        tpp = "cpp",
    },
})
