-- Tab list navigator commands and key mappings

local tab_list = require("extras.tab_list")

-- User command
vim.api.nvim_create_user_command("TabList", function()
    tab_list.show_tab_list()
end, {
    desc = "Show list of open tabs for quick navigation",
})

-- Key mapping
vim.keymap.set("n", "<leader>tl", tab_list.show_tab_list, {
    noremap = true,
    desc = "Show tab list",
})
