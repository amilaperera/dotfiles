return {
    {
        'nvim-tree/nvim-tree.lua',
        dependencies = {
            { 'nvim-tree/nvim-web-devicons' },
        },
        config = function()
            require('nvim-tree').setup {
                on_attach = function(bufnr)
                    local api = require('nvim-tree.api')
                    local function opts(desc)
                        return {
                            desc = 'nvim-tree' .. desc,
                            buffer = bufnr,
                            noremap = true,
                            silent = true,
                            nowait = true
                        }
                    end
                    api.config.mappings.default_on_attach(bufnr)
                    vim.keymap.set('n', 'u', api.tree.change_root_to_parent, opts('Up'))
                end,
                update_focused_file = {
                    enable = true,
                    update_root = true,
                    ignore_list = {},
                },
            }

            -- open/close
            vim.keymap.set('n', '<Leader>e', ':NvimTreeToggle<CR>')
            -- reveal file in explorer
            vim.keymap.set('n', '<Leader>r', ':NvimTreeFindFile<CR>')
        end,
    }
}

