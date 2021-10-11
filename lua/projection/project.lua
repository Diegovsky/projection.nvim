local Project = {
  path = '';
  name = nil;
}
local meta ={
 __tostring = function(self)
    return self.name
  end;
  __index = Project;
  __type = 'Project';
  __len = function(self) return #self.path end,
}

function Project:from_json(json)
  assert(json.path, 'Table does not have "path" key')
  assert(json.name, 'Table does not have "name" key')
  return setmetatable(json, meta)
end

function Project:new(path)
  path = vim.trim(path)
  -- Remove trailing /
  path = path:gsub('/$', '')
  -- Get dir name
  local name = vim.fn.fnamemodify(path, ':t')
  return setmetatable({path=path, name=name}, meta)
end

return setmetatable(Project, {__call=Project.new})
