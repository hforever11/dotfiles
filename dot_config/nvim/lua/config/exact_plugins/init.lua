return {
  "nvim-lua/plenary.nvim",
  {
    "andymass/vim-matchup",
    event = "BufReadPost",
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },
  {
    "christoomey/vim-tmux-navigator",
    init = function()
      -- デフォルトの C-h/j/k/l マッピングを無効化
      vim.g.tmux_navigator_no_mappings = 1
    end,
    config = function()
      -- C-h/j/k/l でペイン移動（Vim内ウィンドウがなければtmuxペインへ）
      vim.keymap.set({ 'n', 't' }, '<C-h>', '<Cmd>TmuxNavigateLeft<CR>')
      vim.keymap.set({ 'n', 't' }, '<C-j>', '<Cmd>TmuxNavigateDown<CR>')
      vim.keymap.set({ 'n', 't' }, '<C-k>', '<Cmd>TmuxNavigateUp<CR>')
      vim.keymap.set({ 'n', 't' }, '<C-l>', '<Cmd>TmuxNavigateRight<CR>')
    end,
  },
}
