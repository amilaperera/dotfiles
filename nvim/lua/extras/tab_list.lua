-- Tab list navigator
-- Shows all tabs in a floating window and allows quick navigation

local M = {}

--- Convert number to letter sequence (1->a, 26->z, 27->aa, 28->ab, etc.)
--- @param num number The number to convert
--- @return string The letter sequence
local function number_to_letters(num)
    local letters = ""
    while num > 0 do
        num = num - 1
        letters = string.char(97 + (num % 26)) .. letters
        num = math.floor(num / 26)
    end
    return letters
end

--- Get shortened filename
--- @param path string The file path
--- @return string The shortened filename
local function shorten_path(path)
    if path == "" then
        return "[No Name]"
    end
    -- Get just the filename without directory
    return vim.fn.fnamemodify(path, ":t")
end

--- Get all window buffers for a tab
--- @param tabnr number The tab number
--- @return table List of window buffers
local function get_tab_buffers(tabnr)
    local windows = vim.fn.tabpagewinnr(tabnr, "$")
    local buffers = {}

    for winnum = 1, windows do
        local bufnr = vim.fn.tabpagebuflist(tabnr)[winnum]
        if bufnr and bufnr > 0 then
            local bufname = vim.fn.bufname(bufnr)
            local shortened = shorten_path(bufname)
            table.insert(buffers, shortened)
        end
    end

    return buffers
end

--- Show tab list in floating window
function M.show_tab_list()
    local num_tabs = vim.fn.tabpagenr("$")
    local current_tab = vim.fn.tabpagenr()

    if num_tabs == 0 then
        vim.notify("No tabs open", vim.log.levels.WARN)
        return
    end

    -- Build tab list
    local lines = {}
    local tab_numbers = {}
    local letter_to_tab = {}

    for tabnr = 1, num_tabs do
        local buffers = get_tab_buffers(tabnr)
        local files_str = table.concat(buffers, " | ")
        local letter = number_to_letters(tabnr)
        local line = "[" .. letter .. "] " .. files_str

        table.insert(lines, line)
        table.insert(tab_numbers, tabnr)
        letter_to_tab[letter] = tabnr
    end

    -- Create buffer
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    -- Calculate window size
    local max_width = 0
    for _, line in ipairs(lines) do
        max_width = math.max(max_width, #line)
    end

    local width = math.min(max_width + 2, vim.o.columns - 4)
    local height = math.min(num_tabs, vim.o.lines - 4)

    -- Calculate center position
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    -- Create floating window centered on screen
    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
    })

    -- Move cursor to current tab
    vim.api.nvim_win_set_cursor(win, { current_tab, 0 })

    -- Set buffer options
    vim.api.nvim_buf_set_option(buf, "modifiable", false)

    -- Set window options to show cursorline that moves with cursor
    vim.api.nvim_win_set_option(win, "cursorline", true)

    -- Close window helper
    local close_window = function()
        if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
        end
        if vim.api.nvim_buf_is_valid(buf) then
            vim.api.nvim_buf_delete(buf, { force = true })
        end
    end

    -- Handle tab selection
    local select_tab = function()
        local line_num = vim.api.nvim_win_get_cursor(win)[1]
        local selected_tab = tab_numbers[line_num]

        if selected_tab then
            close_window()
            vim.cmd("tabnext " .. selected_tab)
        end
    end

    -- Key mappings with nowait to avoid delays
    vim.keymap.set("n", "<CR>", select_tab, { buffer = buf, noremap = true, silent = true, nowait = true })
    vim.keymap.set("n", "q", close_window, { buffer = buf, noremap = true, silent = true, nowait = true })
    vim.keymap.set("n", "<Esc>", close_window, { buffer = buf, noremap = true, silent = true, nowait = true })
    vim.keymap.set("n", "j", "j", { buffer = buf, noremap = true, nowait = true })
    vim.keymap.set("n", "k", "k", { buffer = buf, noremap = true, nowait = true })

    -- Add letter key mappings for quick tab selection with nowait to avoid delays
    for letter, tabnr in pairs(letter_to_tab) do
        vim.keymap.set("n", letter, function()
            close_window()
            vim.cmd("tabnext " .. tabnr)
        end, { buffer = buf, noremap = true, silent = true, nowait = true })
    end

    -- Auto-close when leaving window
    vim.api.nvim_create_autocmd("WinLeave", {
        buffer = buf,
        callback = close_window,
    })
end

return M
