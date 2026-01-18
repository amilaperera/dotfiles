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
    { "nvim-tree/nvim-web-devicons", opts = {} },

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
    -- require("plugins.catppuccin_colorscheme"),

    -- git related stuff
    require("plugins.git"),

    -- diffview
    require("plugins.diffview"),

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
            vim.keymap.set(
                "n",
                "[<TAB>",
                "<cmd>Hi<<CR>",
                { silent = true, desc = "nearest pattern highlight backward" }
            )
            vim.keymap.set("n", "]<TAB>", "<cmd>Hi><CR>", { silent = true, desc = "nearest pattern highlight forward" })
            vim.keymap.set("n", "[<CR>", "<cmd>Hi{<CR>", { silent = true, desc = "nearest highlight backward" })
            vim.keymap.set("n", "]<CR>", "<cmd>Hi}<CR>", { silent = true, desc = "nearest highlight forward" })
        end,
    },

    -- treesitter support to auto close/rename tags
    {
        "windwp/nvim-ts-autotag",
        config = function()
            ---@diagnostic disable-next-line: missing-fields
            require("nvim-ts-autotag").setup({
                opts = {
                    -- Defaults
                    enable_close = true, -- Auto close tags
                    enable_rename = true, -- Auto rename pairs of tags
                    enable_close_on_slash = false, -- Auto close on trailing </
                },
            })
        end,
    },

    -- terminal
    require("plugins.terminal"),

    -- ai stuff
    require("plugins.ai.copilot"),
    require("plugins.ai.opencode"),
})
