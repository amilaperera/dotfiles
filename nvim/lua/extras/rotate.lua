-- returns element e from table t if found, otherwise returns nil
local M = {}
local find_ext = function(t, e)
    for i = 1, #t do
        if t[i] == e then
            return i
        end
    end
    return nil
end

local get_next_file = function()
    local fn = vim.fn
    local ext = fn.expand("%:e")

    local map = { "c", "cpp", "cc", "cxx", "h", "hpp", "hxx", "ipp", "ixx" }

    local index = find_ext(map, ext)
    if index == nil then
        return
    end

    local root_part = fn.expand("%:p:r")

    -- find from the index to the end
    for i = index + 1, #map do
        local next = root_part .. "." .. map[i]
        if fn.filereadable(next) == 1 then
            return next
        end
    end

    -- find from the start to the index
    for i = 1, index - 1 do
        local next = root_part .. "." .. map[i]
        if fn.filereadable(next) == 1 then
            return next
        end
    end

    vim.api.nvim_err_writeln("Couldn't find an alternative file for " .. vim.fn.expand("%:t"))
end

-- rotate files (works only with c++ projects)
M.rotate_file = function(options)
    local next_file = get_next_file()
    if next_file == nil then
        return
    end

    -- we know that rotate file exists by now
    -- TODO: what happens if the current file has got updates without being saved ??
    options = options or { open = "edit" }
    vim.cmd(options["open"] .. next_file)
end

return M
