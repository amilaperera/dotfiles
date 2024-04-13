local M = {}

-- pretty print using vim.inspect
function M.P(obj)
    print(vim.inspect(obj))
end

function M.table_contains(tbl, item)
    for _, v in pairs(tbl) do
        if v == item then
            return true
        end
    end
    return false
end

-- Very basic mapping generator you can use for prev/next commands.
-- Supports counting.
function M.create_expr_mapping_family(mode, map, cmd, item)
    local tbl = { previous = "[", next = "]" }
    for k, v in pairs(tbl) do
        vim.keymap.set(mode, v .. map, function()
            return "<cmd>" .. vim.v.count1 .. cmd .. k .. "<CR>"
        end, { expr = true, silent = true, desc = "Go to [count] " .. k .. " item in " .. item })
    end
end

return M
