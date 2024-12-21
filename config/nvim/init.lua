-- bootstrap lazy

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  }
end

vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "

-- load plugins

require("lazy").setup("plugins", {
  defaults = { lazy = true },
  ui = {
    icons = {
      ft = "",
      lazy = "󰂠 ",
      loaded = "",
      not_loaded = "",
    },
  },
  change_detection = { enabled = false },
  install = { colorscheme = { "catppuccin" } },
})

require "mappings"
require "options"
require "autocmds"
