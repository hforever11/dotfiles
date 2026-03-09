vim.g.mapleader = " "

local keymap = vim.keymap

keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
keymap.set("i", "<C-g><C-u>", "<Esc>gUiwgi", { desc = "Uppercase word" })
keymap.set("i", "<C-g><C-l>", "<Esc>guiwgi", { desc = "Lowercase word" })
keymap.set("i", "<C-g><C-k>", "<Esc>bgUlgi", { desc = "Uppercase previous char" })
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

keymap.set("n", "/", "/\\v", { desc = "Search with very magic" })
keymap.set("n", "?", "/\\V", { desc = "Search literal (very nomagic)" })

keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

keymap.set("n", "x", '"_d', { desc = "Delete without yanking" })
keymap.set("n", "X", '"_D', { desc = "Delete to end of line without yanking" })
keymap.set("x", "x", '"_x', { desc = "Delete selection without yanking" })
keymap.set("x", "p", "P", { desc = "Paste without overwriting register" })
keymap.set("x", "<", "<gv", { desc = "Indent left and reselect" })
keymap.set("x", ">", ">gv", { desc = "Indent right and reselect" })


keymap.set("n", "i", function()
  return vim.fn.empty(vim.fn.getline(".")) == 1 and '"_cc' or "i"
end, { expr = true, desc = "Insert with auto indent on empty line" })
keymap.set("n", "A", function()
  return vim.fn.empty(vim.fn.getline(".")) == 1 and '"_cc' or "A"
end, { expr = true, desc = "Append with auto indent on empty line" })
keymap.set("o", "x", "d", { desc = "Use x as d in operator-pending mode" })

keymap.set("o", "i<space>", "iW", { desc = "Inner WORD" })
keymap.set("x", "i<space>", "iW", { desc = "Inner WORD" })

keymap.set("", "M", function()
  return vim.fn.expand("<cword>"):match("end") and "%" or "g%"
end, { expr = true, remap = true, desc = "Jump to matching bracket" })

-- q prefix: use q register only for macros
local function q_prefix()
  if vim.fn.reg_recording() ~= "" then
    return "q"
  end

  local ok, char = pcall(vim.fn.getcharstr)
  if not ok then
    return ""
  end

  local mappings = {
    q = "qq",             -- マクロ記録開始
    o = "<Cmd>only!<CR>", -- ウィンドウ1つに
    t = "<C-^>",          -- 前のバッファ
  }

  return mappings[char] or ""
end

keymap.set("n", "q", q_prefix, { expr = true, remap = true, desc = "Q prefix or stop recording" })

-- Q to execute macro in q register
keymap.set("n", "Q", function()
  if vim.fn.reg_recording() ~= "" then
    return "q@q"
  else
    return "@q"
  end
end, { expr = true, desc = "Execute macro in q register" })

keymap.set("n", "<leader>cp", function()
  local path = vim.fn.expand("%")
  vim.fn.setreg("+", path)
  vim.notify("Copied: " .. path)
end, { desc = "Copy relative path" })
keymap.set("n", "<leader>cP", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify("Copied: " .. path)
end, { desc = "Copy absolute path" })

keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

-- a" selects inside quotes (override default behavior)
for _, quote in ipairs({ '"', "'", "`" }) do
  vim.keymap.set({ "x", "o" }, "a" .. quote, "2i" .. quote)
end
