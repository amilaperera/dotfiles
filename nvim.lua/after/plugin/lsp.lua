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

-- make sure these servers are installed
lsp.ensure_installed({
    'clangd',
    'lua_ls',
})

-- open definition in a new tab/ horizontal split/ vertical split
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        -- definition on splits/tabs
        vim.keymap.set('n', 'gV', "<cmd>vsplit | lua vim.lsp.buf.definition()<CR>", { buffer = args.buf })
        vim.keymap.set('n', 'gS', "<cmd>split | lua vim.lsp.buf.definition()<CR>", { buffer = args.buf })
        vim.keymap.set('n', 'gN', "<cmd>tab split | lua vim.lsp.buf.definition()<CR>", { buffer = args.buf })
        vim.keymap.set('n', '<leader>F', function() vim.lsp.buf.format() end, { buffer = args.buf })
    end,
})

lsp.setup_nvim_cmp({
    mapping = cmp_mappings
})

lsp.set_preferences({
    sign_icons = {}
})

-- tweaking lsp config depending on the environment.
require('lspconfig').clangd.setup({
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
vim.diagnostic.config(lsp.defaults.diagnostics({
  virtual_text = false
}))

lsp.setup()
