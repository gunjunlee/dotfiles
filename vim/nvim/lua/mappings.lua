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
map("i", "<S-left>", "<esc>v<left>")
map("i", "<S-right>", "<esc>v<right>")
map("v", "<S-left>", "<left>")
map("v", "<S-right>", "<right>")

-- comment line
--map("i", { "[[", "]]" }, "<esc>gcci")
--map({ "n", "v" }, { "[[", "]]" }, "gcc")
