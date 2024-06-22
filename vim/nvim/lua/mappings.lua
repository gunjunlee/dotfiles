require "nvchad.mappings"

-- add yours here

-- ignore vim undefined error

local map = vim.keymap.set
local unmap = vim.keymap.del

-- insert mode to normal mode
local function i2n()
  if vim.fn.mode() == "i" then
    -- check if cursor is at the end of the line
    if vim.fn.col(".") == vim.fn.col("$") then
      -- just enter normal mode
      vim.api.nvim_command("stopinsert")
    else
      -- enter normal mode and move right
      vim.api.nvim_command("stopinsert")
      vim.api.nvim_command("normal! l")
    end
  end
end

map("n", ";", ":", { desc = "cmd enter command mode" })
map("i", "jk", i2n, { expr = true, silent = true, noremap = true, desc = "jk to normal mode" })
map("i", "kl", i2n, { expr = true, silent = true, noremap = true, desc = "jk to normal mode" })
map("i", ":wq", "<esc>:wq<cr>i")
map("i", ":Wq", "<esc>:wq<cr>i")
map("i", ":WQ", "<esc>:wq<cr>i")
map("i", ":w", "<esc>:w<cr>i")
map("i", ":q", "<esc>:q<cr>i")
map("i", ":q!", "<esc>:q!<cr>i")

-- indenting using tab
-- map("i", "<tab>", "<esc>>>i")
map("i", "<s-tab>", "<esc><<i")
map({ "n", "v" }, "<tab>", ">>")
map({ "n", "v" }, "<s-tab>", "<<")

-- using shift + arrow to select text
-- not move cursor when
map("i", "<S-left>", "<esc>v")
map("i", "<S-right>", "<esc>v")
map("i", "<S-up>", "<esc>v")
map("i", "<S-down>", "<esc>v")
map("v", "<S-left>", "<left>", { noremap = true })
map("v", "<S-right>", "<right>", { noremap = true })
map("v", "<S-up>", "<up>", { noremap = true })
map("v", "<S-down>", "<down>", { noremap = true })
map("v", "<left>", "<esc><left>")
map("v", "<right>", "<esc><right>")
map("v", "<up>", "<esc><up>")
map("v", "<down>", "<esc><down>")
map("n", "<S-left>", "v<left>", { noremap = true })
map("n", "<S-right>", "v<right>", { noremap = true })
map("n", "<S-up>", "v<up>", { noremap = true })
map("n", "<S-down>", "v<down>", { noremap = true })

-- delete visual selection with backspace
map("v", "<bs>", "x")

-- delete character with backspace
map("n", "<bs>", "hxi")

-- undo, redo
map("n", "<c-z>", "<cmd>undo<cr>")
map("n", "<c-r>", "<cmd>redo<cr>")
map("i", "<c-z>", "<esc><cmd>undo<cr>i")
map("i", "<c-r>", "<esc><cmd>redo<cr>i")

-- close suggestion with esc
local function close_suggestion()
  if require("cmp").visible() then
    return require("cmp").close()
  else
    return "<esc>"
  end
end
map("i", "<esc>", close_suggestion, { expr = true, noremap = true, silent = true })

-- page up, page down to half page up, half page down
-- and move scroll to keep cursor at the same position
function _G.half_page_ctrl(is_up)
  local half_page = math.floor(vim.api.nvim_win_get_height(0) / 2)
  local is_insert = vim.fn.mode() == "i"
  if is_insert then
    i2n()
  end

  if is_up then
    vim.api.nvim_command('normal! ' .. half_page .. 'kzz')
  else
    vim.api.nvim_command('normal! ' .. half_page .. 'jzz')
  end

  if is_insert then
    vim.api.nvim_command('startinsert')
  end
end

map({ "i", "n" }, "<PageUp>", '<cmd>lua half_page_ctrl(true)<cr>', { noremap = true })
map({ "i", "n" }, "<PageDown>", '<cmd>lua half_page_ctrl(false)<cr>', { noremap = true })


-- mapping dg to gd (go to definition)
map("n", "dg", "gd")


-- goto next/prev cursor position in jump list
map("n", "<a-left>", "<c-o>")
map("n", "<a-right>", "<c-i>")

-- use enter to accept completion when command line is open
function _G.enter_completion()
  if vim.fn.pumvisible() == 1 then
    return vim.api.nvim_replace_termcodes("<c-y>", true, true, true)
  else
    return "<cr>"
  end
end
map("c", "<cr>", enter_completion, { expr = true, noremap = true })

-- split window
map("n", "b:", "<cmd>split<cr>")
map("n", "bs", "<cmd>split<cr>")
map("n", "b-", "<cmd>split<cr>")
map("n", "sh", "<cmd>split<cr>")
map("n", "hs", "<cmd>split<cr>")
map("n", "b|", "<cmd>vsplit<cr>")
map("n", "b%", "<cmd>vsplit<cr>")
map("n", "sv", "<cmd>vsplit<cr>")
map("n", "vs", "<cmd>vsplit<cr>")

-- open file in new buffer
map({ "i", "n" }, "<c-o>", "<cmd>Telescope find_files<cr>")
-- open file in new buffer and split window
map({ "i", "n" }, "<c-O>", "<cmd>vsplit<cr><cmd>Telescope find_files<cr>")

-- Telescope (rg, fd, bf, bb)
-- search in current directory
map("n", "rg", "<cmd>Telescope live_grep<cr>")
map("n", "fd", "<cmd>Telescope find_files<cr>")
map("n", "bf", "<cmd>Telescope buffers<cr>")
map("n", "bb", "<cmd>Telescope buffers<cr>")

-- move between windows
map("i", "<c-w>h", "<cmd>i2n()<cr><c-w>hi")
map("i", "<c-w>j", "<cmd>i2n()<cr><c-w>ji")
map("i", "<c-w>k", "<cmd>i2n()<cr><c-w>ki")
map("i", "<c-w>l", "<cmd>i2n()<cr><c-w>li")

-- close window
map("i", "<c-w>q", "<cmd>i2n()<cr><c-w>c")

-- toggleterm
map({ "i", "n", "t" }, "<c-t><c-t>", "<cmd>ToggleTerm<cr>")
map("t", "<c-t>t", "<cmd>wincmd k<cr>")

function _G.toggleterm_split()
  local terms = require("toggleterm.terminal").get_all(true)
  if #terms == 0 then
    return '<cmd>execute 1 . "ToggleTerm"<cr>'
  elseif #terms == 1 then
    return '<cmd>execute 2 . "ToggleTerm"<cr>'
  else
    print("Cannot open more than 3 terminal windows")
  end
end

map("t", "<esc>", "<c-\\><c-n>")
map("t", "jk", "<c-\\><c-n>")
map("t", "<c-b>|", toggleterm_split, { expr = true, noremap = true })

