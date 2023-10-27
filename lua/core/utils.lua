local M = {}

function M.lazy_require(module)
  return setmetatable({}, {
    __index = function(_, key)
      return function(...)
        return require(module)[key](...)
      end
    end
  })
end

return M
