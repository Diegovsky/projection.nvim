local M = {
  project_list = {},
  has_changed = false,
}

local list_helper = {
  -- Rebalances the most recently opened projects.
  rebalance = function(self)
    for _, proj in ipairs(self) do
      local old_weight = proj.weight
      -- Restrict weights to values between 0 and #self
      proj.weight = math.min(#self, math.max(0, proj.weight - 1))
      -- If a project weight was changed, it should be written to disk.
      if not M.has_changed and old_weight ~= proj.weight then
        M.has_changed = true
      end
    end
  end,
  sort = function(self)
    table.sort(self, function(p1, p2)
      return p1.weight > p2.weight
    end)
  end,
}

-- Hide helper methods from `pairs` by using a metatable with `__index` fallback.
setmetatable(M.project_list, { __index = list_helper })

local Project = require "projection.project"

function M.add_projects(projs)
  for _, proj in ipairs(projs) do
    table.insert(M.project_list, Project:from_json(proj))
  end
end

function M.add_project(folder)
  local project = Project(folder)
  if not vim.tbl_contains(M.project_list, project) then
    table.insert(M.project_list, project)
    M.has_changed = true
  end
end

function M.remove_project_by_index(index)
  assert(index)
  table.remove(M.project_list, index)
  M.has_changed = true
end

function M.remove_project(folder)
  for i, f in ipairs(M.project_list) do
    if folder.path == f.path then
      table.remove(M.project_list, i)
      M.has_changed = true
      return
    end
  end
  print(('Project "%s" does not exist.'):format(folder))
end

local function max_name_len()
  local l = 0
  for _, proj in ipairs(M.project_list)
  do
    if #proj.name > l then
      l = #proj.name
    end
  end
  return l
end

local function lpad(str, len)
    return str .. string.rep(' ', len - #str)
end

function M.choose_project(prompt, callback)
  local padding = max_name_len()
  vim.ui.select(
    M.project_list,
    {
      prompt = prompt,
      format_item = function(proj)
        return ("%s (%s)"):format(lpad(proj.name, padding), proj.path)
      end or tostring,
    },
    function(c, i)
      if c ~= nil and i ~= nil then
        callback(c, i)
      end
    end
  )
end

return M
