
-- leader settings before the plugins are loaded (otherwise wrong leader)
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- utils are needed before anything else
require('common')

-- options
require('options')

-- basic mappings, nothing plugins specific
require('mappings')

-- load all 3rd party plugins
require('lazy_plugins')

-- extra stuff
require('extras')
