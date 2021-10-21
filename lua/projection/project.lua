local Project = {
  path = '';
  name = nil;
  weight = 0;
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
  local function ensure_field(obj, name)
    assert(obj[name], ('Table does not have "%s" key'):format(name))
  end
  ensure_field(json, 'name')
  ensure_field(json, 'path')
  ensure_field(json, 'weight')
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
