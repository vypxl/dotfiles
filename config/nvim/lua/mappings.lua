-- All key mapping not specific to plugins.
-- Plugin mappings are defined in each plugin config.

local map = vim.keymap.set

-- general

map("n", "<leader>s", "<cmd> w<CR>", { desc = "Save file" })
map("n", "<Esc>", "<cmd> noh<CR>", { desc = "Clear highlights" })
map("n", "<CR>", "o<ESC>", { desc = "Insert newline below" })
map({ "n", "i", "v" }, "<C-s>", "<cmd> w<CR>", { desc = "Save file" })

map("n", "<A-Down>", "<cmd> m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-Up>", "<cmd> m .-2<CR>==", { desc = "Move line up" })
map("n", "<A-k>", "<cmd> m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-j>", "<cmd> m .-2<CR>==", { desc = "Move line up" })
map("i", "<A-Down>", "<cmd> m .+1<CR>", { desc = "Move line down" })
map("i", "<A-Up>", "<cmd> m .-2<CR>", { desc = "Move line up" })

map("n", "<leader>x", "<cmd> bd<CR>", { desc = "Close current buffer" })

-- allow up down movements across wrapped lines

map({ "n", "x", "v" }, "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { desc = "Move down", expr = true })
map({ "n", "x", "v" }, "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { desc = "Move up", expr = true })
map({ "n", "x", "v" }, "<Down>", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { desc = "Move down", expr = true })
map({ "n", "x", "v" }, "<Up>", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { desc = "Move up", expr = true })

-- visual indentation should not exit visual mode

map("v", ">", ">gv", { desc = "Indent +" })
map("v", "<", "<gv", { desc = "Indent -" })

-- lsp

map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { desc = "Go to definition" })
map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { desc = "Go to declaration" })
map("n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", { desc = "Go to type definition" })
map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", { desc = "Go to implementation" })
map("n", "gh", "<cmd>ClangdSwitchSourceHeader<CR>", { desc = "Switch C header and source file" })
map("n", "K", "<cmd>Lspsaga hover_doc<CR>", { desc = "Lsp Hover" })
map("n", "<leader>r", "<cmd>Lspsaga rename<CR>", { desc = "Lsp rename" })
map("n", "<leader>c", "<cmd>Lspsaga code_action<CR>", { desc = "Lsp code action" })
map("n", "<leader>l", "<cmd>Lspsaga show_line_diagnostics<CR>", { desc = "Lsp line diagnostics" })
map("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", { desc = "Lsp goto next diagnostic" })
map("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { desc = "Lsp goto previous diagnostic" })
