local M = {}
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")


local function expand_path(path)
  local segments = {}
  for segment in path:gmatch("/?([^/]+)") do
    if segment == ".." and #segments > 0 then
      table.remove(segments)
    elseif segment ~= ".." then
      table.insert(segments, segment)
    end
  end
  return "/" .. table.concat(segments, "/")
end

local function find_dirs(opts, ctx)
  -- picker used to look for a directory and call a callback with the result
  opts = opts or {}
  opts.cwd = opts.cwd or vim.loop.cwd()
  if string.sub(opts.cwd, -1) ~= '/' then
    opts.cwd = opts.cwd .. '/'
  end

  pickers
    .new(require('telescope.themes').get_dropdown(opts), {
      prompt_title = "Find Directory",
      default_text = opts.cwd,
      finder = finders.new_oneshot_job({"find", opts.cwd, "-type", "d", "-not", "-path", "*/.git/*", "-not", "-path", "*/node_modules/*"}, opts),
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()
          if selection then
            actions.close(prompt_bufnr)
            ctx.find_dirs_callback(selection[1], ctx)
            return
          end
          actions.close(prompt_bufnr)
          opts.cwd = expand_path(action_state.get_current_line())
          find_dirs(opts, ctx)
        end)
        map({"i", "n"}, "<C-u>", function(_prompt_bufnr)
          -- alternative to writing writing `..`
          actions.close(_prompt_bufnr)
          opts.cwd = vim.fn.fnamemodify(opts.cwd, ":p:h:h")
          find_dirs(opts, ctx)
        end)
        map({"i", "n"}, "<C-d>", function(_prompt_bufnr)
          -- Continue to search for sub directories in the current selection
          local selection = action_state.get_selected_entry()
          if selection then
            actions.close(_prompt_bufnr)
            opts.cwd = selection[1]
            find_dirs(opts, ctx)
          end
        end)
        return true
      end
    }):find()
end

function M.cwd_change_wrapper(picker)
  -- Allows the usage of <C-l> mapping to change the current working directory and come back to the picker
  -- To use with find files picker do: cwd_change_wrapper(require("telescope.builtin").find_files)(opts)
  local function wrapper(opts)
    opts = opts or {}
    local ctx = {}
    ctx.find_dirs_callback = function(cwd, callback_ctx)
      opts.cwd = cwd
      opts.default_text = callback_ctx.current_line
      picker(opts)
    end
    local attach_mappings = function(_, map)
      map({"i", "n"}, "<C-l>", function(prompt_bufnr)
        ctx.current_line = action_state.get_current_line()
        actions.close(prompt_bufnr)
        find_dirs(opts, ctx)
      end)
      return true
    end
    if opts.attach_mappings then
      attach_mappings = function(prompt_bufnr, map)
        local result = opts.attach_mappings(prompt_bufnr, map)
        attach_mappings(prompt_bufnr, map)
        return result
      end
    end
    opts.attach_mappings = attach_mappings
    picker(opts)
  end
  return wrapper
end

return M
