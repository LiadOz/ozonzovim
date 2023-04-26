local M = {}

require('host_configs.witchapewter.test')
function M.setup()
end

vim.o.clipboard ='unnamedplus'

local rt = require("rust-tools")
rt.setup()


return M
