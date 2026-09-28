# fzf / nvim palette.lua / hunk / statusline palette.sh に generated.nix が展開する
{
  name = "catppuccin";
  variant = "latte";

  # Catppuccin Latte (base/mantle は眩しさを抑えるため公式より二段暗い。Ghostty background と揃える)
  palette = {
    base = "#dce0e8";
    mantle = "#d3d8e2";
    surface0 = "#ccd0da";
    surface1 = "#bcc0cc";
    overlay0 = "#9ca0b0";
    text = "#4c4f69";
    rosewater = "#dc8a78";
    blue = "#1e66f5";
    red = "#d20f39";
    yellow = "#df8e1d";
    # 公式 Latte の #40a02b は OKLCH 色相 140° でライト背景だとオリーブに濁る。
    # herdr の accent (Claude Code ライトテーマの diffAddedWord) と同じ 146° に揃える
    green = "#2f9d44";
    sky = "#04a5e5";
    mauve = "#8839ef";
    peach = "#fe640b";
  };
}
