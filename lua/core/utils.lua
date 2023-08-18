local M = {}

function M.lazy_require(module)
  return setmetatable({}, {
    __index = function(_, key)
      return function(...)
        print(string.format('requiring %s %s', module, key))
        return require(module)[key](...)
      end
    end
  })
end

return M
