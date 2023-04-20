-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local function on_attach(bufnr)
    local api = require('nvim-tree.api')

    local function opts(desc)
        return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end
    api.config.mappings.default_on_attach(bufnr)
    vim.keymap.set('n', 'u', api.tree.change_root_to_parent, opts('Up'))
end

-- Setup with some options
-- Desperately trying to bring NvimTree closer to plain old (but yet good) NerdTree
require("nvim-tree").setup({
    on_attach = on_attach,
    renderer = {
        icons = {
            symlink_arrow = '➛',
            show = {
                file = false,
                folder = false,
                folder_arrow = true,
                git = true,
                modified = true
            },
            glyphs = {
                symlink = '',
                folder = {
                    symlink = '',
                    arrow_closed = '▸',
                    arrow_open = '▾',
                },
                git = {
                    unstaged = '✗',
                    staged = '✓',
                    unmerged = '⌥',
                    renamed = '➜',
                    untracked = '★',
                    deleted = '⊖',
                    ignored = '◌',
                },
            },
        },
    },
    update_focused_file = {
        enable = true,
        update_root = true,
        ignore_list = {},
    },
})

-- open/close
vim.keymap.set('n', '<leader><Enter>', ':NvimTreeToggle<CR>')
-- reveal file
vim.keymap.set('n', '<leader>r', ':NvimTreeFindFile<CR>')
