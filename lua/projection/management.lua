local M = {
  project_list = {}
}

local Project = require'projection.project'

function M.add_projects(projs)
  for _, proj in ipairs(projs) do
    table.insert(M.project_list, Project:from_json(proj))
  end
end

function M.add_project(folder)
  local project = Project(folder)
  if not vim.tbl_contains(M.project_list, project) then
    table.insert(M.project_list, project)
  end
end

function M.remove_project_by_index(index)
  table.remove(M.project_list, index)
end

function M.remove_project(folder)
  for i, f in ipairs(M.project_list) do
    if folder.path == f.path then
      table.remove(M.project_list, i)
      return
    end
  end
  print(('Project "%s" does not exist.'):format(folder))
end

return M
