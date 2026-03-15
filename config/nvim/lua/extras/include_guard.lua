-- Include guard generator for C/C++ header files
-- Generates include guards based on git root path for .h, .hpp, .hh, .hxx files

local M = {}

--- Get the git root directory of the current file
--- @return string|nil The absolute path to git root, or nil if not in a git repository
local function get_git_root()
    local handle = io.popen("git rev-parse --show-toplevel 2>/dev/null")
    if not handle then
        return nil
    end
    local result = handle:read("*a")
    handle:close()

    if result and result ~= "" then
        -- Remove trailing newline
        return result:gsub("\n$", "")
    end
    return nil
end

--- Convert a path to a valid C preprocessor identifier
--- @param path string The path to convert
--- @return string The converted identifier
local function path_to_identifier(path)
    -- Replace path separators and invalid characters with underscores
    local identifier = path:gsub("[/%-.]", "_")
    -- Remove leading underscores from relative paths
    identifier = identifier:gsub("^_+", "")
    -- Convert to uppercase
    identifier = identifier:upper()
    return identifier
end

--- Generate include guard for the current file
--- @return string|nil guard_code The include guard code or nil if error
--- @return string identifier_or_error The identifier or error message
local function generate_include_guard()
    local filename = vim.fn.expand("%:p")

    -- Check if file has a header extension
    local is_header = filename:match("%.h$")
        or filename:match("%.hpp$")
        or filename:match("%.hh$")
        or filename:match("%.hxx$")

    if not is_header then
        return nil, "Not a header file (.h, .hpp, .hh, .hxx)"
    end

    local identifier

    -- Try to get git root directory
    local git_root = get_git_root()
    if git_root then
        -- Get relative path from git root
        local relative_path = filename:sub(#git_root + 2) -- +2 to skip the '/' after git_root
        identifier = path_to_identifier(relative_path)
    else
        -- Fall back to just the filename
        local basename = vim.fn.fnamemodify(filename, ":t")
        identifier = path_to_identifier(basename)
    end

    -- Create include guard code
    local guard_code = string.format("#ifndef %s\n#define %s\n\n\n\n#endif // %s\n", identifier, identifier, identifier)

    return guard_code, identifier
end

--- Insert include guard at the beginning of the file
--- @return nil
function M.insert_include_guard()
    local guard_code, identifier_or_error = generate_include_guard()

    if not guard_code then
        vim.notify(identifier_or_error, vim.log.levels.ERROR)
        return
    end

    -- Insert at the beginning of the file
    local lines = vim.split(guard_code, "\n", { plain = true })
    vim.api.nvim_buf_set_lines(0, 0, 0, false, lines)

    -- Move cursor to the blank line after #define (where code should go)
    vim.fn.cursor(4, 1)

    vim.notify("Include guard inserted: " .. identifier_or_error, vim.log.levels.INFO)
end

return M
