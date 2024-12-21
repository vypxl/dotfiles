local set = vim.opt

set.termguicolors = true
vim.cmd [[colorscheme catppuccin]]

set.laststatus = 3
set.showmode = false

-- Editing
set.clipboard = "unnamedplus"

set.shiftwidth = 2
set.tabstop = 2
set.softtabstop = 2
set.expandtab = true
set.smartindent = true

set.list = true
set.listchars = { tab = "▸ ", trail = "·", extends = "#" }
set.fillchars = { foldopen = "▾", foldclose = "▸", foldsep = "│", eob = " " }

set.encoding = "utf-8"

set.ignorecase = true
set.smartcase = true

set.mouse = "a"
set.mousefocus = false

-- Appearance
set.number = true
set.numberwidth = 2
set.ruler = true
set.cursorline = true

-- disable intro and search wrap message
set.shortmess:append "sI"

set.signcolumn = "yes"
set.splitbelow = true
set.splitright = true
set.timeoutlen = 400
set.undofile = true

set.updatetime = 250

-- wrap line oh left right motion
set.whichwrap:append "<>[]hl"

-- Disable swap and backup
set.swapfile = false
set.backup = false

-- Folding
set.foldlevelstart = 99
set.foldnestmax = 4
set.foldmethod = "expr"
set.foldexpr = "nvim_treesitter#foldexpr()"

set.hidden = true
set.guifont = { "FiraCode Nerd Font", ":h14" }

set.title = true

set.shell = "bash"

-- local config
set.exrc = true
set.secure = true

-- filetypes
vim.filetype.add { extension = { frag = "glsl", vert = "glsl" } }
