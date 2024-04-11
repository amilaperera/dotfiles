return {
    {
        'VonHeikemen/lsp-zero.nvim',
        dependencies = {
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
        },
        config = function()
            local lsp = require('lsp-zero')
            lsp.preset('recommended')

            local cmp = require('cmp')
            cmp.setup({
                snippet = {
                    -- REQUIRED - you must specify a snippet engine
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                    end,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' }, -- For luasnip users.
                }, {
                    { name = 'buffer' },
                })
            })

            local ls = require('luasnip')
            vim.keymap.set({"i", "s"}, "<C-L>", function() ls.jump( 1) end, {silent = true})
            vim.keymap.set({"i", "s"}, "<C-J>", function() ls.jump(-1) end, {silent = true})

            local lsp_zero = require('lsp-zero')
            lsp_zero.on_attach(function(client, bufnr)
                -- see :help lsp-zero-keybindings
                -- to learn the available actions
                lsp_zero.default_keymaps({ buffer = bufnr })
            end)

            -- open definition in a new tab/ horizontal split/ vertical split
            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(args)
                    -- definition on splits/tabs
                    vim.keymap.set('n', 'gV', "<cmd>vsplit | lua vim.lsp.buf.definition()<CR>", { buffer = args.buf })
                    vim.keymap.set('n', 'gS', "<cmd>split | lua vim.lsp.buf.definition()<CR>", { buffer = args.buf })
                    vim.keymap.set('n', 'gN', "<cmd>tab split | lua vim.lsp.buf.definition()<CR>", { buffer = args.buf })
                    vim.keymap.set('n', '<Leader>F', function() vim.lsp.buf.format() end, { buffer = args.buf })
                end,
            })

            require('mason').setup({})
            require('mason-lspconfig').setup({
                ensure_installed = { 'clangd', 'lua_ls' },
                handlers = {
                    lsp_zero.default_setup,
                },
            })

            lsp.set_preferences({
                sign_icons = {}
            })

            -- tweaking lsp config depending on the environment.
            lsp.configure('clangd', {
                cmd = { 'clangd', '-j=4' }
            })

            -- configure lua language server for neovim
            require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

            -- letting lsp know that vim is a part of global namespace
            lsp.configure('lua_ls', {
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { 'vim' }
                        }
                    }
                }
            })

            -- virtual text for diagnostics - just not for me!!
            vim.diagnostic.config({
                virtual_text = false
            })
            lsp.setup()
        end
    }
}
