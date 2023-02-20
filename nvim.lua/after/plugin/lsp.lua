local lsp = require('lsp-zero')
lsp.preset('recommended')

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
    })

-- open definition in a new tab/ horizontal split/ vertical split
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        vim.keymap.set('n', 'gV', "<cmd>vsplit | lua vim.lsp.buf.definition()<CR>", { buffer = args.buf })
        vim.keymap.set('n', 'gD', "<cmd>tab split | lua vim.lsp.buf.definition()<CR>", { buffer = args.buf })
        vim.keymap.set('n', 'gX', "<cmd>split | lua vim.lsp.buf.definition()<CR>", { buffer = args.buf })
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
lsp.configure('clangd', {
    cmd = { 'clangd', '-j=4' }
})

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

lsp.setup()
