local M = {}

local open = require'plenary.context_manager'.open
local with = require'plenary.context_manager'.with

function M.load_projects(filepath)
  local projectlist = with(open(filepath, 'r'),
      function(file) return vim.json.decode(file:read('*all')) end)
  return projectlist
end
function M.store_projects(filepath, projectlist)
  local json = vim.json.encode(projectlist)
  with(open(filepath, 'w'), function(file) file:write(json) end)
end
return M
