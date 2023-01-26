local lsp = require('lsp-zero')
lsp.preset('recommended')

lsp.configure('clangd', {
  cmd = {'clangd', '-j=4'}
})

lsp.setup()

