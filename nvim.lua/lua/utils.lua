-- returns element e from table t if found, otherwise returns nil
local M = {}
local find_ext = function(t, e)
    for i = 1, #t do
        if t[i] == e then return i end
    end
    return nil
end

local get_alternate_file = function()
    local ext = vim.fn.expand('%:e')

    local map = { 'c', 'cpp', 'cc', 'cxx', 'h', 'hpp', 'hxx', 'ipp', 'ixx' }

    local index = find_ext(map, ext)
    if  index == nil then return end

    local root_part = vim.fn.expand('%:p:r')

    -- find from the index to the end
    for i = index+1, #map do
        local next = root_part .. '.' .. map[i]
        if vim.fn.filereadable(next) == 1 then
            return next
        end
    end

    -- find from the start to the index
    for i = 1, index - 1 do
        local next = root_part .. '.' .. map[i]
        if vim.fn.filereadable(next) == 1 then
            return next
        end
    end
end

-- alternate files (works only with c++ projects)
M.alternate = function(options)
    local alternate_file = get_alternate_file()
    if alternate_file == nil then return end

    -- we know that alternate file exists by this time
    -- TODO: what happens if the current file has got updates without being saved ??
    options = options or { open = 'edit'}
    vim.cmd(options['open'] .. alternate_file)
end

return M
