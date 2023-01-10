local M = {}

M.nvimtree = {
  n = {
    ["<C-b>"] = { "<cmd> NvimTreeToggle <CR>", "toggle nvimtree" },
  },
}

M.general = {
  n = {
    ["tt"] = { "<cmd> w<CR>", "Save file" },
    ["<LEFT>"] = { "<cmd> bp<CR>", "Switch to previous buffer" },
    ["<Right>"] = { "<cmd> bn<CR>", "Switch to next buffer", opts = { silent = true } },
    ["<A-j>"] = { "<cmd> m .+1<CR>==", "Move line down" },
    ["<A-k>"] = { "<cmd> m .-2<CR>==", "Move line up" },
    ["<Enter>"] = { "o<Esc>", "Insert blank line" },
  },
  i = {
    ["<C-s>"] = { "<cmd> w<CR>", "Save file" },
    ["<A-j>"] = { "<cmd> m .+1<CR>", "Move line down" },
    ["<A-k>"] = { "<cmd> m .-2<CR>", "Move line up" },
  },
  v = {
    ["<A-j>"] = { ":m '>+1<CR>gv=gv", "Move selection one line down", opts = { silent = true } },
    ["<A-k>"] = { ":m '<-2<CR>gv=gv", "Move selection one line up", opts = { silent = true } },
  },
}

-- Make <leader>/ dot-repeatable (use Comment.nvim's <Plug> mapping instead of calling it via lua)
M.comment = {
  n = {
    ["<leader>/"] = { "<Plug>(comment_toggle_linewise_current)", "toggle comment" },
  },

  v = {
    ["<leader>/"] = { "<Plug>(comment_toggle_linewise_visual)", "toggle comment" },
  },
}

M.trouble = {
  n = {
    ["<leader>dd"] = { "<cmd>TroubleToggle<CR>", "Toggle trouble" },
    ["<leader>dw"] = { "<cmd>Trouble workspace_diagnostics<CR>", "Trouble workspace diagnostics" },
    ["<leader>df"] = { "<cmd>Trouble document_diagnostics<CR>", "Trouble document diagnostics" },
    ["<leader>dl"] = { "<cmd>Trouble loclist<CR>", "Trouble location list" },
    ["<leader>dq"] = { "<cmd>Trouble quickfix<CR>", "Trouble quickfix" },
    ["<leader>dr"] = { "<cmd>Trouble lsp_references<CR>", "Trouble lsp references" },
  },
}

M.persistence = {
  n = {
    ["<leader>sl"] = { "lua require('persistence').load({ last = true })<CR>", "Load last session" },
    ["<leader>sd"] = { "lua require('persistence').load()<CR>", "Load session for current directory" },
  },
}

M.lspconfig = {
  plugin = true,

  n = {
    ["gD"] = {
      function()
        vim.lsp.buf.declaration()
      end,
      "lsp declaration",
    },

    ["gd"] = {
      function()
        vim.cmd([[Lspsaga peek_definition]])
      end,
      "lsp definition",
    },

    ["K"] = {
      function()
        vim.cmd([[Lspsaga hover_doc]])
      end,
      "lsp hover",
    },

    ["gi"] = {
      function()
        vim.lsp.buf.implementation()
      end,
      "lsp implementation",
    },

    ["<leader>ls"] = {
      function()
        vim.lsp.buf.signature_help()
      end,
      "lsp signature_help",
    },

    ["<leader>D"] = {
      function()
        vim.lsp.buf.type_definition()
      end,
      "lsp definition type",
    },

    ["<leader>ra"] = {
      function()
        require("nvchad_ui.renamer").open()
      end,
      "lsp rename",
    },

    ["<leader>ca"] = {
      function()
        vim.cmd([[Lspsaga code_action]])
      end,
      "lsp code_action",
    },

    ["gr"] = {
      function()
        vim.cmd([[Lspsaga lsp_finder]])
      end,
      "lsp references",
    },

    ["<leader>f"] = {
      function()
        vim.diagnostic.open_float()
      end,
      "floating diagnostic",
    },

    ["<leader>ld"] = {
      function()
        vim.cmd([[Lspsaga show_line_diagnostics]])
      end,
      "show line diagnostics",
    },

    ["<leader>cd"] = {
      function()
        vim.cmd([[Lspsaga show_cursor_diagnostics]])
      end,
      "show line diagnostics",
    },

    ["[d"] = {
      function()
        vim.diagnostic.goto_prev()
      end,
      "goto prev",
    },

    ["]d"] = {
      function()
        vim.diagnostic.goto_next()
      end,
      "goto_next",
    },

    -- ["<leader>q"] = "",

    ["<leader>o"] = {
      function()
        vim.cmd([[LSoutlineToggle]])
      end,
      "Toggle symbol outline",
    },

    ["<leader>fm"] = {
      function()
        vim.lsp.buf.format({ async = true })
      end,
      "lsp formatting",
    },

    ["<leader>wa"] = {
      function()
        vim.lsp.buf.add_workspace_folder()
      end,
      "add workspace folder",
    },

    ["<leader>wr"] = {
      function()
        vim.lsp.buf.remove_workspace_folder()
      end,
      "remove workspace folder",
    },

    ["<leader>wl"] = {
      function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end,
      "list workspace folders",
    },
  },
}

return M
