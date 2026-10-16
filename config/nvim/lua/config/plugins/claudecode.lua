-- herdr の隣のペインで動いている Claude Code とつなぐ (Claude 側で /ide を打って Neovim を選ぶ)。
-- ファイルや選択範囲は <leader>as / <leader>ab で渡したときだけ Claude に伝わる。
-- Claude の編集提案はこの nvim の diff で開く (:w か <leader>aa で採用、:q か <leader>ad で却下)

-- Visual の選択行を Claude に渡す。track_selection を切ると :ClaudeCodeSend は使えないので、
-- 行範囲を :ClaudeCodeAdd に渡す
local function send_selection()
  local first, last = vim.fn.line("v"), vim.fn.line(".")
  if first > last then
    first, last = last, first
  end
  vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "nx", false)
  vim.cmd(("ClaudeCodeAdd %% %d %d"):format(first, last))
end

return {
  "coder/claudecode.nvim",
  -- Claude から見つけてもらうにはサーバーが起動している必要があるので、キーを待たずに読み込む
  event = "VeryLazy",
  opts = {
    -- Claude は herdr のペインで動かすので、nvim の中にはターミナルを開かない
    terminal = { provider = "none" },
    -- 開いているファイルや選択中のテキストを自動で Claude に送らない。
    -- 社外秘や本番データを開いたときに、意図せず次のメッセージに乗るのを防ぐ
    track_selection = false,
    -- 提案の diff は新しいタブで開く。編集中のウィンドウ配置を崩さず、閉じると元のタブに戻る
    diff_opts = { open_in_new_tab = true },
  },
  keys = {
    { "<leader>as", send_selection,                   mode = "x",                desc = "Send selection to Claude" },
    { "<leader>as", "<cmd>ClaudeCodeTreeAdd<cr>",     ft = "snacks_picker_list", desc = "Add file to Claude" },
    { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>",       desc = "Add buffer to Claude" },
    { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>",  desc = "Accept Claude diff" },
    { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>",    desc = "Deny Claude diff" },
  },
}
