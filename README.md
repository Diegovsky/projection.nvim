# projection.nvim
Project management for neovim.

[![Quick guide](https://asciinema.org/a/441435.svg)](https://asciinema.org/a/441435)


## Install
```vim
" With Plug
Plug 'Diegovsky/projection.nvim'
```

## Setup
```lua
-- To use the default settings
require'projection'.init()
```

## How-to
```lua
local projection = require'projection'

-- Add a new project
projection.add_project()

-- Remove a project
projection.remove_project()

-- Go to a project
projection.goto_project()

-- Save the current project list to disk
-- You don't need to call this manually because it's called on vim exit.
projection.save_projects()
```
