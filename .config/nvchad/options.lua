local set = vim.opt
local g = vim.g

-- Disable swap and backup
set.swapfile = false
set.backup = false

-- Editing
set.shiftwidth = 2
set.tabstop = 2
set.softtabstop = 2
set.smarttab = true
set.expandtab = true

set.list = true
set.listchars = { tab = '▸ ', trail = '·', extends = '#' }
set.fillchars = { foldopen = '▾', foldclose = '▸', foldsep = '│' }

set.encoding = 'utf-8'

-- Folding
set.foldlevelstart = 99
set.foldnestmax = 4
set.foldmethod = 'expr'
set.foldexpr = 'nvim_treesitter#foldexpr()'
set.foldcolumn = "1"

-- Editor
set.hidden = true

set.number = true
set.relativenumber = true

set.title = true

set.shell = 'bash'

-- Clipboard
set.clipboard = 'unnamedplus'

-- Mouse
set.mouse = 'a'
set.mousefocus = false

-- Searching
set.ignorecase = true
set.smartcase = true

-- Temporary fix for ionide
g['fsharp#fsautocomplete_command'] = { 'fsautocomplete', '--adaptive-lsp-server-enabled' }
