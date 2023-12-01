local M = { "akinsho/toggleterm.nvim", version = "*", event = "VeryLazy" }

local config = {
  size = 20,
  open_mapping = [[<c-\>]],
  autochdir = true,
  direction = "float",
  shell = "fish",
  float_opts = {
    border = "curved",
  },
  winbar = { enabled = true },
}

Toggleterms = {}

M.config = function()
  require("toggleterm").setup(config)
  local Terminal = require("toggleterm.terminal").Terminal
  Toggleterms.lazygit = Terminal:new({ cmd = "lazygit", hidden = true })
  Toggleterms.lazygit_yadm = Terminal:new({ cmd = "lazygit -w ~ -g ~/.local/share/yadm/repo.git", hidden = true })
  Toggleterms.htop = Terminal:new({ cmd = "htop", hidden = true })
  Toggleterms.python = Terminal:new({ cmd = "python", hidden = true })
  Toggleterms.julia = Terminal:new({ cmd = "julia", hidden = true })
  Toggleterms.run = Terminal:new({ cmd = "just; read -s -n 1", hidden = true })
end

return M
