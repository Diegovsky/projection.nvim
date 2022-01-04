local M = {
  is_ready = false;
  is_loading = false;
  should_sort = false;
  should_title = true;
  store_file = require'projection.utils'.default_project_store_path();
}
local management = require'projection.management'
local store = require'projection.store'
local utils = require'projection.utils'
local workspace = require'projection.workspace'

local function wait_for_init()
  if M.is_ready then
    return
  elseif M.is_loading then
    while M.is_loading do
    end
  else
    error('Projection hasn\'t been initialized.', 2)
  end
end

function M.add_project()
  wait_for_init()
  local path = vim.fn.input('Path of project: ', vim.fn.getcwd(), 'dir')
  if path == nil or #path == 0 then
    return
  end

  local should_add = utils.ask('Add path "%s" to the project list?', path)
  if should_add then
    management.add_project(path)
  end
end

function M.list_projects()
  wait_for_init()
  return management.project_list
end

function M.remove_project()
  wait_for_init()
  local project, index = utils.choose(management.project_list, "Select a project:")
  if project == nil then
    return
  end

  local should_remove = utils.ask('Remove path "%s" from the project list?', project)
  if should_remove then
    management.remove_project_by_index(index)
  end
end

function M.goto_project()
  wait_for_init()
  if M.should_sort then
    management.project_list:sort()
  end
  local answer = utils.choose(management.project_list, "Go to:")
  if answer then
    if M.should_sort then
      answer.weight = #management.project_list
      management.project_list:rebalance()
    end
    vim.cmd(("exec 'cd' '%s'"):format(answer.path))
    if M.should_title then
      vim.o.title = true
      utils.set_title(answer.name)
    end
  end
end

function M.save_projects(force)
  force = force or false
  -- Only store if user has changed the project list
  --  or if explicitly asked to.
  if management.has_changed or force then
    require'projection.store'.store_projects(M.store_file, management.project_list)
  end
end

local function set_prop(tbl, name)
  local prop = tbl[name]
  if prop ~= nil then
    return prop
  else
    return M[name]
  end
end

-- Loads all the projects asynchronously
-- @param t.store_file string @comment The file to load the project list (Default: see utils.default_project_store_path)
-- @param t.should_sort boolean @comment Whether the project list should place the most accessed projects first.
-- @param t.should_title boolean @comment Whether neovim should change the terminal title to the project name.
function M.init(t)
  t = t or {}
  set_prop(t, 'store_file')
  set_prop(t, 'should_sort')
  set_prop(t, 'should_title')
  if not M.is_ready and not M.is_loading then
    require'plenary.async'.run(function()
        M.is_loading = true
        local success, projects = pcall(store.load_projects, M.store_file)
        if success then
          management.add_projects(projects)
        end
      end,
      function()
        M.is_ready = true
        M.is_loading = false
        -- Save project list on exit.
        vim.cmd("au VimLeavePre * :lua require'projection'.save_projects()")
      end)
  end
end

return M
