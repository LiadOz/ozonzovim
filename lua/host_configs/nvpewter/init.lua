local M = {}
function M.pre_plugin_setup()
  local plugins = require('core.plugins')

  plugins.add_plugin({
    "ngemily/vim-vp4"
  })
  plugins.add_plugin({
    "https://gitlab-master.nvidia.com/asubramaniam/gp.nvim",
    config = function()
      require("gp").setup()
      local mappings = {
        {'a', ':GpAppend<cr>', 'Generate code after this line'},
        {'r', ':GpRewrite<cr>', 'Rewrite code'},
        {'e', ':GpExplain<cr>', 'Explain code'},
      }
      for _, map in ipairs(mappings) do
        vim.keymap.set({'n', 'v'}, '<leader>a' .. map[1], map[2], { desc = map[3] })
      end
    end
  })
  --plugins.add_plugin({
    --"Exafunction/codeium.nvim",
    --dependencies = {
        --"nvim-lua/plenary.nvim",
        --"hrsh7th/nvim-cmp",
    --},
    --config = function()
        --require("codeium").setup({
          --api = {
             --host = "codeium-poc.hwinf-scm-aws.nvidia.com",
             --path = "_route/api_server",
             --portal_url = "codeium-poc.hwinf-scm-aws.nvidia.com",
          --},
          --enterprise_mode = true,
          --virtual_text = {
            --enabled = true,
          --}
        --})
    --end
  --})
  -- one day
  --plugins.add_plugin({
    --"yetone/avante.nvim",
    --event = "VeryLazy",
    --lazy = false,
    --version = false,
    --opts = {
      ---- add any opts here
    --},
    --build = "make",
    --dependencies = {
      --"stevearc/dressing.nvim",
      --"nvim-lua/plenary.nvim",
      --"MunifTanjim/nui.nvim",
      --"hrsh7th/nvim-cmp",
      --"nvim-tree/nvim-web-devicons",
    --},
  --})
end

function M.post_plugin_setup()
end

return M
