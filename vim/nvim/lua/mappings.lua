require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set
local unmap = vim.keymap.del

map("n", ";", ":", { desc = "cmd enter command mode" })
map("i", "jk", "<esc>")
map("i", ":wq", "<esc>:wq<cr>i")
map("i", ":w", "<esc>:w<cr>i")
map("i", ":q", "<esc>:q<cr>i")

-- indenting using tab
map("i", "<tab>", "<esc>>>i")
map("i", "<s-tab>", "<esc><<i")
map({ "n", "v" }, "<tab>", ">>")
map({ "n", "v" }, "<s-tab>", "<<")

-- using shift + arrow to select text
map("i", "<S-left>", "<esc>vh")
map("i", "<S-right>", "<esc>vl")
map("i", "<S-up>", "<esc>vk")
map("i", "<S-down>", "<esc>vj")
map("v", "<S-left>", "h")
map("v", "<S-right>", "l")
map("v", "<S-up>", "k")
map("v", "<S-down>", "j")
map("v", "<left>", "<esc>h")
map("v", "<right>", "<esc>l")
map("v", "<up>", "<esc>k")
map("v", "<down>", "<esc>j")
map("n", "<S-left>", "vh")
map("n", "<S-right>", "vl")
map("n", "<S-up>", "vk")
map("n", "<S-down>", "vj")

-- undo, redo
map("n", "<c-z>", "<cmd>undo<cr>")
map("n", "<c-r>", "<cmd>redo<cr>")
map("i", "<c-z>", "<esc><cmd>undo<cr>i")
map("i", "<c-r>", "<esc><cmd>redo<cr>i")
