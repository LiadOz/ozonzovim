local M = {}

require('host_configs.witchapewter.test')
function M.setup()
end

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.nvimdap = {
  install_info = {
    url = "~/projects/nvim_plugins/tree-sitter-nvim-dap", -- local path or git repo
    files = { "src/parser.c" },
  },
  filetype = "dap-repl", -- if filetype does not match the parser name
}

vim.filetype.add({ extension = {
  dap = 'dap-repl'
} })


return M
