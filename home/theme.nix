# テーマの単一ソース。palette から各ツール向けの設定ファイルを ~/.config に生成する。
# 生成しない (直リンクの設定に色を手書きしている) ため手動で合わせる箇所:
#   config/herdr/config.toml [theme.custom] panel_bg = mantle / accent = green
{ lib, ... }:
let
  name = "catppuccin";
  variant = "latte";

  # Catppuccin Latte (base/mantle は眩しさを抑えるため公式より二段暗い)
  p = {
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

  title = s: lib.toUpper (lib.substring 0 1 s) + lib.substring 1 (-1) s;
in
{
  # config/ghostty/config が config-file で読む
  xdg.configFile."theme/ghostty".text = ''
    # home/theme.nix から home-manager が生成する。編集は theme.nix 側で行うこと
    background = ${p.base}
  '';

  xdg.configFile."fzf/config".text = ''
    # 色は home/theme.nix から home-manager が生成する。編集は theme.nix 側で行うこと
    --height 40%
    --layout=reverse
    --border

    --color=bg+:${p.surface0},spinner:${p.rosewater},hl:${p.red}
    --color=fg:${p.text},header:${p.red},info:${p.mauve},pointer:${p.rosewater}
    --color=marker:${p.rosewater},fg+:${p.text},prompt:${p.mauve},hl+:${p.red}
  '';

  xdg.configFile."hunk/config.toml".text = ''
    # home/theme.nix から home-manager が生成する。編集は theme.nix 側で行うこと。
    # "auto" はライト背景だと github-light-default に解決されるため使わない。
    # custom でビルトイン catppuccin-latte を継承し、背景系だけ dotfiles の
    # 暗め Latte (Ghostty background / herdr panel_bg と同じ値) に上書きする
    theme = "custom"

    [custom_theme]
    base = "${name}-${variant}"
    label = "Catppuccin ${title variant} (dotfiles)"
    background = "${p.base}"
    panel = "${p.mantle}"
    panelAlt = "${p.surface0}"
    text = "${p.text}"
  '';

  # nvim (config/nvim/lua/config/core/theme.lua) が dofile で読む
  xdg.configFile."theme/palette.lua".text = ''
    -- home/theme.nix から home-manager が生成する。編集は theme.nix 側で行うこと
    local M = {
      name = "${name}",
      variant = "${variant}",
      transparent_background = false,
    }

    function M.palette()
      return {
    ${lib.concatStringsSep "\n" (lib.mapAttrsToList (n: v: "    ${n} = \"${v}\",") p)}
      }
    end

    return M
  '';

  # claude statusline (config/claude/statusline.sh) が source で読む
  xdg.configFile."theme/palette.sh".text = ''
    # home/theme.nix から home-manager が生成する。編集は theme.nix 側で行うこと
    ${lib.concatStringsSep "\n" (lib.mapAttrsToList (n: v: "THEME_${lib.toUpper n}=\"${v}\"") p)}
  '';
}
