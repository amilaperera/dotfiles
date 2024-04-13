-- bootstrapping.
-- directly from https://github.com/folke/lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Plugins
return require("lazy").setup({
    -- custom statusline, telescope, nvim-tree etc. rely on this
    { "nvim-tree.nvim-web-devicons" },

    -- telescope and its extensions
    require("plugins.telescope"),

    -- highlighting, navigating, editing, selecting etc.
    require("plugins.treesitter"),

    -- lsp configuration
    require("plugins.lsp"),

    -- auto-completions
    require("plugins.completion"),

    -- auto-formatters
    require("plugins.formatters"),

    -- file explorer
    require("plugins.nvimtree"),

    -- colorschemes
    require("plugins.kanagawa_colorscheme"),

    -- git related stuff
    require("plugins.git"),

    -- async run
    require("plugins.asyncrun"),

    -- auto pairs
    {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup()
        end,
    },

    -- tmux integration
    { "tpope/vim-tbone" },

    -- commenter
    {
        "scrooloose/nerdcommenter",
        config = function()
            vim.cmd([[
                let g:NERDSpaceDelims = 1
                let g:NERDRemoveExtraSpaces = 1
                imap <C-c> <plug>NERDCommenterInsert
            ]])
        end,
    },

    -- highligher
    {
        "azabiong/vim-highlighter",
        config = function()
            -- highlight plugin
            vim.keymap.set("n", "[<CR>", "<cmd>Hi{<CR>", { silent = true, desc = "nearest highlight backward" })
            vim.keymap.set("n", "]<CR>", "<cmd>Hi}<CR>", { silent = true, desc = "nearest highlight forward" })
        end,
    },

    -- markdown preview
    {
        "iamcco/markdown-preview.nvim",
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
        config = function()
            vim.keymap.set(
                "n",
                "<F5>",
                ":MarkdownPreviewToggle<CR>",
                { silent = true, desc = "Toggle markdown preview" }
            )
        end,
    },
})
