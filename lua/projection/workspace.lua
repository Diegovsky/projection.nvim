local M = {}

local Path = require'plenary.path'

function M.settings_file()
  local settings_file = '.projection'
  return Path:new(vim.fn.getcwd(), settings_file)
end

function M.load_settings()
  local sefile = M.settings_file()
  if sefile:exists() then
    dofile(tostring(sefile))
  end
end

return M
