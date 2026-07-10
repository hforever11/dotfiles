-- バッファ内 Markdown 装飾レンダリング。編集中も描画が持続し、カーソル行だけ生テキストに戻る。
-- 画像のインライン表示は snacks.image、GitHub 完全再現の別窓ビューは arto.vim が担当
return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  ft = { "markdown" },
  opts = {},
}
