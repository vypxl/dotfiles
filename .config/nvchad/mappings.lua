local M = { }

M.nvimtree = {
  n = {
    ["<C-b>"] = { "<cmd> NvimTreeToggle <CR>", "toggle nvimtree" },
  }
}

M.general = {
  n = {
    ["tt"] = { ":w<CR>", "Save file" },
    ["<LEFT>"] = { ":bp<CR>", "Switch to previous buffer" },
    ["<Right>"] = { ":bn<CR>", "Switch to next buffer" },
    ["<A-j>"] = { ":m .+1<CR>==", "Move line down" },
    ["<A-k>"] = { ":m .-2<CR>==", "Move line up" },
    ["<Enter>"] = { "o<Esc>", "Insert blank line" }
  },
  i = {
    ["<C-s>"] = { "<C-o>:w<CR>", "Save file" },
    ["<A-j>"] = { "<C-o>:m .+1<CR>", "Move line down" },
    ["<A-k>"] = { "<C-o>:m .-2<CR>", "Move line up" },
  },
  v = {
    ["<A-j>"] = { ":m '>+1<CR>gv=gv", "Move selection one line down" },
    ["<A-k>"] = { ":m '<-2<CR>gv=gv", "Move selection one line up" },
  }
}

return M
