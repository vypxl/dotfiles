-- alpha.nvim is my startup screen
local M = { "goolord/alpha-nvim", enabled = true, lazy = false }

local function button(sc, txt, keybind)
  local sc_ = sc:gsub("%s", ""):gsub("SPC", "<leader>")

  local opts = {
    position = "center",
    text = txt,
    shortcut = sc,
    cursor = 5,
    width = 36,
    align_shortcut = "right",
    hl = "AlphaButtons",
  }

  if keybind then
    opts.keymap = { "n", sc_, keybind, { noremap = true, silent = true } }
  end

  return {
    type = "button",
    val = txt,
    on_press = function()
      local key = vim.api.nvim_replace_termcodes(sc_, true, false, true) or ""
      vim.api.nvim_feedkeys(key, "normal", false)
    end,
    opts = opts,
  }
end

-- dynamic header padding
local fn = vim.fn
local marginTopPercent = 0.225
local headerPadding = fn.max { 2, fn.floor(fn.winheight(0) * marginTopPercent) }

M.opts = {
  layout = {
    { type = "padding", val = headerPadding },
    {
      type = "text",
      val = {
        "               █████████████▀▀▀▀▀▀▀▀▀▀▀▀▀█████████████",
        "               ████████▀▀░░░░░░░░░░░░░░░░░░░▀▀████████",
        "               ██████▀░░░░░░░░░░░░░░░░░░░░░░░░░▀██████",
        "               █████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░█████",
        "               ████░░░░░▄▄▄▄▄▄▄░░░░░░░░▄▄▄▄▄▄░░░░░████",
        "               ████░░▄██████████░░░░░░██▀░░░▀██▄░░████",
        "               ████░░███████████░░░░░░█▄░░▀░░▄██░░████",
        "               █████░░▀▀███████░░░██░░░██▄▄▄█▀▀░░█████",
        "               ██████░░░░░░▄▄▀░░░████░░░▀▄▄░░░░░██████",
        "               █████░░░░░█▄░░░░░░▀▀▀▀░░░░░░░█▄░░░█████",
        "               █████░░░▀▀█░█▀▄▄▄▄▄▄▄▄▄▄▄▄▄▀██▀▀░░█████",
        "               ██████░░░░░▀█▄░░█░░█░░░█░░█▄▀░░░░██▀▀▀▀",
        "               ▀░░░▀██▄░░░░░░▀▀█▄▄█▄▄▄█▄▀▀░░░░▄█▀░░░▄▄",
        "               ▄▄▄░░░▀▀██▄▄▄▄░░░░░░░░░░░░▄▄▄███░░░▄██▄",
        "               ██████▄▄░░▀█████▀█████▀██████▀▀░░▄█████",
        "               ██████████▄░░▀▀█▄░░░░░▄██▀▀▀░▄▄▄███▀▄██",
        "               ███████████░██░▄██▄▄▄▄█▄░▄░████████░███",
        "                                                                       ",
        "                                                                     ",
        "       ████ ██████           █████      ██                     ",
        "      ███████████             █████                             ",
        "      █████████ ███████████████████ ███   ███████████   ",
        "     █████████  ███    █████████████ █████ ██████████████   ",
        "    █████████ ██████████ █████████ █████ █████ ████ █████   ",
        "  ███████████ ███    ███ █████████ █████ █████ ████ █████  ",
        " ██████  █████████████████████ ████ █████ █████ ████ ██████ ",
        "                                                                       ",
      },
      opts = {
        position = "center",
        hl = "AlphaHeader",
      },
    },

    { type = "padding", val = 2 },

    {
      type = "group",
      val = {
        button("Enter", "  Just type", ":enew<CR>"),
        button("SPC f", "  Find File  ", ":Telescope find_files<CR>"),
        button("SPC o", "  Recent File  ", ":Telescope oldfiles<CR>"),
        button("SPC w", "  Find Word  ", ":Telescope live_grep<CR>"),
      },
      opts = {
        spacing = 1,
      },
    },
  },
}

return M
