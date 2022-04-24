local M = {
  last_auname = nil
}

--- Wraps a function and caches it's return value.
--- @param f function
--- @return function
function M.cached(f)
  local value
  return function(...)
    if value then
      return value
    else
      return f(...)
    end
  end
end

--- Returns the default file path where projects will be saved.
function M.default_project_store_path()
  local folder = vim.env['XDG_STATE_HOME'] or (vim.env['HOME'] .. '/.local/state')
  return folder .. '/projects.json'
end

--- Ask a yes-or-no question to the user.
--- Returns `true` if the answer was `y`
--- @param text string
--- @vararg any
--- @return boolean
function M.ask(text, ...)
  local ans = vim.fn.input((text.. " [Y/n] "):format(...))
  return vim.trim(ans):lower():sub(1, 1) == 'y'
end

function M.set_title(name)
  print('a')
  vim.cmd(('set titlestring=%s'):format(name))
  if M.last_auname then
    vim.api.nvim_del_augroup_by_name(M.last_auname)
  end
  local auname = 'Projection#'..name
  vim.api.nvim_create_augroup(auname)
  vim.api.nvim_create_autocmd('BufEnter', {
    pattern = "*";
    callback = function ()
      print('pog')
      vim.lo.titlestring=name
    end
  })
  M.last_auname = auname
end

return M
