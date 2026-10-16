-- :help を日本語で引く。翻訳元は Vim のヘルプなので、Neovim と挙動が違う項目は
-- :h {tag}@en で英語 (Neovim 本体) を開く。help の対象なので遅延読み込みしない
return {
  "vim-jp/vimdoc-ja",
  init = function()
    vim.opt.helplang = { "ja", "en" }
  end,
}
