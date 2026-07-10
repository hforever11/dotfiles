vim.g.mapleader = " "

local keymap = vim.keymap

keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
keymap.set("i", "<C-g><C-u>", "<Esc>gUiwgi", { desc = "Uppercase word" })
keymap.set("i", "<C-g><C-l>", "<Esc>guiwgi", { desc = "Lowercase word" })
keymap.set("i", "<C-g><C-k>", "<Esc>bgUlgi", { desc = "Capitalize word (first letter)" })
keymap.set("i", "<C-g><C-t>", "<Esc>g~iwgi", { desc = "Toggle case word" })
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })
keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR><Esc>", { desc = "Clear search highlights" })

keymap.set({ "n", "x" }, "/", "/\\v", { desc = "Search with very magic" })
keymap.set({ "n", "x" }, "?", "?\\V", { desc = "Search literal backward (very nomagic)" })

keymap.set("n", "n", "nzzzv", { desc = "Next match centered" })
keymap.set("n", "N", "Nzzzv", { desc = "Previous match centered" })
keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down centered" })
keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up centered" })

keymap.set("n", "x", '"_d', { desc = "Delete without yanking" })
keymap.set("n", "X", '"_D', { desc = "Delete to end of line without yanking" })
keymap.set("x", "x", '"_x', { desc = "Delete selection without yanking" })
keymap.set("x", "<", "<gv", { desc = "Indent left and reselect" })
keymap.set("x", ">", ">gv", { desc = "Indent right and reselect" })
keymap.set("n", "J", "mzJ`z", { desc = "Join lines keeping cursor position" })


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

-- cmdheight=0/laststatus=0 だと標準の "recording" 表示が出ず記録中か分からないので通知する
local rec_group = vim.api.nvim_create_augroup("macro_recording_indicator", { clear = true })
local rec_notif

vim.api.nvim_create_autocmd("RecordingEnter", {
  group = rec_group,
  callback = function()
    local msg = "● REC  @" .. vim.fn.reg_recording()
    local ok, notify = pcall(require, "notify")
    if ok then
      rec_notif = notify(msg, vim.log.levels.WARN, { title = "Macro", timeout = false, hide_from_history = true })
    else
      vim.notify(msg, vim.log.levels.WARN, { title = "Macro" })
    end
  end,
})

vim.api.nvim_create_autocmd("RecordingLeave", {
  group = rec_group,
  callback = function()
    local msg = "■ recorded  @" .. vim.v.event.regname
    local ok, notify = pcall(require, "notify")
    if ok then
      notify(msg, vim.log.levels.INFO, { title = "Macro", replace = rec_notif, timeout = 1200 })
    else
      vim.notify(msg, vim.log.levels.INFO, { title = "Macro" })
    end
    rec_notif = nil
  end,
})

keymap.set("n", "<leader>cp", function()
  local path = vim.fn.expand("%:.")
  vim.fn.setreg("+", path)
  vim.notify("Copied: " .. path)
end, { desc = "Copy relative path" })
keymap.set("n", "<leader>cP", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify("Copied: " .. path)
end, { desc = "Copy absolute path" })
keymap.set("n", "<leader>cn", function()
  local name = vim.fn.expand("%:t")
  vim.fn.setreg("+", name)
  vim.notify("Copied: " .. name)
end, { desc = "Copy filename" })
keymap.set("n", "<leader>cN", function()
  local stem = vim.fn.expand("%:t:r")
  vim.fn.setreg("+", stem)
  vim.notify("Copied: " .. stem)
end, { desc = "Copy filename without extension" })

-- C-h/j/k/l: vim のウィンドウ移動、端に達したら herdr/tmux のペインへ抜ける
-- (vim-tmux-navigator 相当。herdr 対応のため自前実装。herdr 内でも TMUX が
-- 継承されているので HERDR_PANE_ID を先に見る)
local function navigate(wincmd_key, direction)
  return function()
    local before = vim.api.nvim_get_current_win()
    vim.cmd.wincmd(wincmd_key)
    if vim.api.nvim_get_current_win() ~= before then
      return
    end
    if vim.env.HERDR_PANE_ID then
      vim.system({ "herdr", "pane", "focus", "--direction", direction, "--pane", vim.env.HERDR_PANE_ID })
    elseif vim.env.TMUX then
      local flags = { left = "-L", down = "-D", up = "-U", right = "-R" }
      vim.system({ "tmux", "select-pane", flags[direction] })
    end
  end
end

keymap.set({ "n", "t" }, "<C-h>", navigate("h", "left"), { desc = "Window/pane left" })
keymap.set({ "n", "t" }, "<C-j>", navigate("j", "down"), { desc = "Window/pane down" })
keymap.set({ "n", "t" }, "<C-k>", navigate("k", "up"), { desc = "Window/pane up" })
keymap.set({ "n", "t" }, "<C-l>", navigate("l", "right"), { desc = "Window/pane right" })

-- <leader>s は Snacks の search 系が使うので、ウィンドウ操作は <leader>w に置く
keymap.set("n", "<leader>wv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>wh", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<leader>we", "<C-w>=", { desc = "Make splits equal size" })
keymap.set("n", "<leader>wx", "<cmd>close<CR>", { desc = "Close current split" })

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

-- a" selects inside quotes (override default behavior)
for _, quote in ipairs({ '"', "'", "`" }) do
  vim.keymap.set({ "x", "o" }, "a" .. quote, "2i" .. quote)
end
