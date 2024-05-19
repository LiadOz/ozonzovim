local plugins = require('core.plugins')

plugins.add_plugin({ "rcarriga/nvim-notify", event = 'VeryLazy', opts = { background_colour = "#000000" } })
plugins.add_plugin({
  "stevearc/dressing.nvim",
  event = 'VeryLazy',
  config = function()
    require('dressing').setup({
      input = {
        enabled = true
      }
    })
  end
})

plugins.add_plugin({
  "nvim-lualine/lualine.nvim",
  event = 'VeryLazy',
  config = function()
    local dap_component = require('debug_config').get_dap_lualine_component()
    require('lualine').setup {
      options = {
        section_separators = { left = '', right = '' },
        component_separators = { left = '|', right = '|' }
      },
      sections = {
        lualine_y = {
          { dap_component }
        },
        lualine_x = { 'hostname', 'fileformat', 'filetype' }
      }
    }
  end
})

plugins.add_plugin({
  'goolord/alpha-nvim',
  event = 'VimEnter',
  config = function()
    local dashboard = require("alpha.themes.dashboard")
    local logo = [[
 ██████╗ ███████╗ ██████╗ ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
██╔═══██╗╚══███╔╝██╔═══██╗████╗  ██║╚══███╔╝██╔═══██╗██║   ██║██║████╗ ████║
██║   ██║  ███╔╝ ██║   ██║██╔██╗ ██║  ███╔╝ ██║   ██║██║   ██║██║██╔████╔██║
██║   ██║ ███╔╝  ██║   ██║██║╚██╗██║ ███╔╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
╚██████╔╝███████╗╚██████╔╝██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
 ╚═════╝ ╚══════╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
      ]]
    local logo_lines = vim.split(logo, '\n')
    dashboard.section.buttons.val = {
      dashboard.button("SPC f f", "󰈞  Find file"),
      dashboard.button("SPC f r", "  Recent"),
      dashboard.button("SPC f g", "󰈬  Live grep"),
      dashboard.button("SPC p o", "  Projects"),
    }
    local version = vim.version()
    local footer = "   v" .. version.major .. "." .. version.minor .. "." .. version.patch
    dashboard.section.footer.val = footer
    local line_count = #logo_lines + 3 + 2 * #dashboard.section.buttons.val + 1
    local header_lines = {}
    for _ = 1, (vim.fn.winheight(0) - line_count) / 2 do
      table.insert(header_lines, "")
    end
    for _, line in ipairs(logo_lines) do
      table.insert(header_lines, line)
    end
    dashboard.section.header.val = header_lines
    require('alpha').setup(dashboard.opts)

    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyVimStarted",
      callback = function()
        local stats = require("lazy").stats()
        local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
        dashboard.section.footer.val = footer .. " ⚡ loaded " .. stats.count .. " plugins in " .. ms .. "ms"
        pcall(vim.cmd.AlphaRedraw)
      end,
    })
  end
})
