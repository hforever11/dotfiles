-- #416bb0 や rgb(...) などの色コードの手前に、その色の見本 (■) を出す。
-- 背景を塗らない virtual 表示にして、マットな配色を崩さない。
-- cssls や tailwindcss が返す色 (LSP の documentColor) もこちらで表示する
-- (Neovim 標準の LSP の色表示は二重になるので plugins/lsp/init.lua で切っている)
return {
  "brenoprata10/nvim-highlight-colors",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    render = "virtual",
  },
}
