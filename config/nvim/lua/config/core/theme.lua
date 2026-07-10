-- home-manager が home/theme.nix から ~/.config/theme/palette.lua を生成する。
-- テーマの編集は theme.nix 側で行うこと
return dofile(vim.fn.expand("~/.config/theme/palette.lua"))
