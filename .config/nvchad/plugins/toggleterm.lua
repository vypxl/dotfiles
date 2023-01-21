local M = {}

M.config = {
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

M.setup = function()
  require("toggleterm").setup(M.config)
  local Terminal = require("toggleterm.terminal").Terminal
  M.lazygit = Terminal:new({ cmd = "lazygit", hidden = true })
  M.lazygit_yadm = Terminal:new({ cmd = "lazygit -w ~ -g ~/.local/share/yadm/repo.git", hidden = true })
  M.htop = Terminal:new({ cmd = "htop", hidden = true })
  M.python = Terminal:new({ cmd = "python", hidden = true })
  M.julia = Terminal:new({ cmd = "julia", hidden = true })
end

return M
