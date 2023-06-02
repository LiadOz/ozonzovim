local function add_line(line)
  local lnum = vim.fn.line('$')
  local lines = {}
  for l in string.gmatch(line, "[^\r\n]+") do
    local formatted_line = ''
    if #lines == 0 then
      formatted_line = 'dap> ' .. l
    else
      formatted_line = '...> ' .. l
    end
    vim.api.nvim_buf_set_lines(0, lnum - 1, lnum - 1, true, {formatted_line})
    vim.cmd('startinsert!')
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<cr>", true, true, true), "n", true)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, true, true), "n", true)
    lnum = lnum + 1
  end
end
--local function add_line(line)
  --local lnum = vim.fn.line('$')
  --line = string.gsub(line, "\n", "")
  --vim.api.nvim_buf_set_lines(0, lnum - 1, lnum, true, {'dap> ' .. line})
  --vim.cmd('startinsert!')
  --vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<cr>", true, true, true), "n", true)
--end


vim.keymap.set('n', 'p', function() add_line(vim.fn.getreg('"')) end, {buffer = 0})
