local M = {}

local ts_utils = require("nvim-treesitter.ts_utils")
local function get_curr_func ()
    local current_node = ts_utils.get_node_at_cursor()
    local bufnr = vim.api.nvim_get_current_buf()

    while current_node do
        if current_node:type() == 'function_definition' then
            break
        end
        current_node = current_node:parent()
    end
    if not current_node then
        return ''
    end
    local name_node = current_node:child(1)
    local func_name = vim.treesitter.query.get_node_text(name_node, bufnr)
    return func_name
end
M.cp_test_path = function (is_pytest)
    local func_name = get_curr_func()
    if not func_name then
        return ''
    end
    local path = vim.fn.expand('%') .. ':'
    print(path)
    if is_pytest then
      path = path .. ':'
    end
    print(path)
    path = path .. func_name
    print(path)
    vim.fn.setreg('*', path)
    require('notify')(path, 'info', {title='Test path'})
    return path
end

return M
