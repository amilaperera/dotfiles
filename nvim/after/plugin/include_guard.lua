-- Include guard user commands and key mappings
-- Provides easy access to include guard generation for header files

local include_guard = require("extras.include_guard")

-- User command
vim.api.nvim_create_user_command("IncludeGuardInsert", function()
    include_guard.insert_include_guard()
end, {
    desc = "Insert include guard at the beginning of the file",
})

-- Key mapping
vim.keymap.set("n", "<leader>hi", include_guard.insert_include_guard, {
    noremap = true,
    desc = "Insert include guard",
})
