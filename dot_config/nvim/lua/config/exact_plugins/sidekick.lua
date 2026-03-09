return {
  "folke/sidekick.nvim",
  opts = {
    nes = {
      enabled = true,
    },
    cli = {
      mux = {
        backend = "tmux",
        enabled = true,
      },
    },
  },
  keys = {
    -- NES: Tab でジャンプ/適用
    {
      "<tab>",
      function()
        if not require("sidekick").nes_jump_or_apply() then
          return "<Tab>"
        end
      end,
      expr = true,
      desc = "Goto/Apply Next Edit Suggestion",
    },
    -- CLI トグル
    {
      "<leader>aa",
      function() require("sidekick.cli").toggle() end,
      desc = "Sidekick Toggle CLI",
    },
    -- CLI ツール選択
    {
      "<leader>as",
      function() require("sidekick.cli").select() end,
      desc = "Sidekick Select Tool",
    },
    -- セッション切断
    {
      "<leader>ad",
      function() require("sidekick.cli").close() end,
      desc = "Sidekick Close CLI",
    },
    -- ファイル送信
    {
      "<leader>af",
      function() require("sidekick.cli").send({ msg = "{file}" }) end,
      desc = "Send File",
    },
    -- 選択範囲送信
    {
      "<leader>av",
      function() require("sidekick.cli").send({ msg = "{selection}" }) end,
      mode = { "x" },
      desc = "Send Visual Selection",
    },
    -- プロンプト選択
    {
      "<leader>ap",
      function() require("sidekick.cli").prompt() end,
      mode = { "n", "x" },
      desc = "Sidekick Select Prompt",
    },
    -- NES トグル
    {
      "<leader>uN",
      function() require("sidekick.nes").toggle() end,
      desc = "Toggle NES",
    },
  },
}
