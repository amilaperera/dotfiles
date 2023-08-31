-- bootstrapping
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

-- Packer installations
return require("packer").startup(function(use)
    use("wbthomason/packer.nvim")

    -- It will be either fzf or telescope
    -- The decision is based on the existence of 'ripgrep'
    -- fzf
    use {
        'ibhagwan/fzf-lua',
        cond = function()
            return vim.fn.executable('rg') == 0
        end
    }

    -- telescope
    use {
        'nvim-telescope/telescope.nvim',
        requires = { {'nvim-lua/plenary.nvim'} },
        cond = function()
            return vim.fn.executable('rg') == 1
        end
    }
    -- telescope extensions
    use {
        'nvim-telescope/telescope-fzf-native.nvim',
        run = 'make',
        cond = function()
            return vim.fn.executable('rg') == 1
        end
    }

    -- file explorer
    use {
        'nvim-tree/nvim-tree.lua',
        requires = {
            'nvim-tree/nvim-web-devicons', -- optional
        },
    }

    -- colorscheme.
    -- Others to consider: edge, gruvbox, catppuccin, onedark
    use("rebelot/kanagawa.nvim")

    -- tree-sitter
    use({ "nvim-treesitter/nvim-treesitter", run = ':TSUpdate' })

    -- lsp
    use({
        'VonHeikemen/lsp-zero.nvim',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },

            -- Snippets
            { 'L3MON4D3/LuaSnip' },
            -- Snippet Collection (Optional)
            { 'rafamadriz/friendly-snippets' },
        }
    })

    -- git integration
    use("tpope/vim-fugitive")
    use("lewis6991/gitsigns.nvim")

    -- auto pairs
    use({
        "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup() end
    })

    -- tmux integration
    use("tpope/vim-tbone")

    -- commenter
    use("scrooloose/nerdcommenter")

    -- async run
    use("skywind3000/asyncrun.vim")

    -- highligher
    use("azabiong/vim-highlighter")

    -- Automatically set up configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end)
