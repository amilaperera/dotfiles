-- A global configurations
vim.g.Environment = {
    Colorscheme = "kanagawa",
    MapLeader = " ",
    UseNerdFonts = true,
    Clangd = "clangd",
}

-- common utilities are needed before anything else
require("common")

-- options
require("options")

-- basic mappings, nothing plugins specific
require("mappings")

-- load all 3rd party plugins
require("lazy_plugins")

-- extra stuff
require("extras")
