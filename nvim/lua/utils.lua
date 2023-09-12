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

return M
