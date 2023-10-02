local lsp = require('lsp-zero')
lsp.preset('recommended')

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
})

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
