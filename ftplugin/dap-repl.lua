--vim.api.nvim_buf_set_option(0, 'buftype', 'prompt')
--vim.fn.prompt_setprompt(0, 'dap> :python: print("hello")')
--vim.wo.conceallevel = 1
--vim.wo.concealcursor = 'ni'
local session = require('dap').session()
local lang
if session then
  lang = session.config.repl_lang
else
  lang = 'python'
end
local injections = {}
injections['nvimdap'] = '((user_input_statement) @content @combined (#set! language ' .. lang .. '))'
local tsparser = vim.treesitter.get_parser(0, 'nvimdap', {injections = injections})
vim.treesitter.highlighter.new(tsparser)
