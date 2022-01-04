# projection.nvim
Project management for neovim.

[![Quick guide](https://asciinema.org/a/441435.svg)](https://asciinema.org/a/441435)


## Install
```vim
" With Plug
Plug 'Diegovsky/projection.nvim'
```

## Features
 - Basic project management
   - Add a new project
   - Remove a project
   - Go to project
   - Recently opened projects (`should_sort=true`)

Note: If you want vscode-like workspace local settings, consider also using [direnv](https://github.com/direnv/direnv.vim).

## Setup
Add this to your neovim config file (init.lua):
```lua
-- To use the default settings
require'projection'.init()
```

init.vim:
```vim
" To use the default settings
lua require'projection'.init()
```

### Possible settings
The function `projection.init` takes an optional table with the following keys:
| Name | Default Value | Description |
| ---- | ------------- | ----------- |
| store_file | `$XDG_STATE_HOME/projects.json` | Where Projection.nvim will save your projects |
| should_sort | `false` | Whether Projection.nvim should sort the projects by most recent access |
| should_title | `true` | Whether Projection.nvim should change the terminal title to reflect currently opened project |

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
