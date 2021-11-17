local M = {}

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

function M.choose(list, prompt)
  local choice, index
  vim.ui.select(list, {prompt=prompt}, function(c, i) choice = c; index = i end)
  return choice, index
end

return M
