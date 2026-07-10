# theme.nix から生成する設定ファイル (旧 chezmoi テンプレート)
{ lib, ... }:
let
  theme = import ./theme.nix;
  p = theme.palette;
  title = s: lib.toUpper (lib.substring 0 1 s) + lib.substring 1 (-1) s;
in
{
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
    base = "catppuccin-${theme.variant}"
    label = "Catppuccin ${title theme.variant} (dotfiles)"
    background = "${p.base}"
    panel = "${p.mantle}"
    panelAlt = "${p.surface0}"
    text = "${p.text}"
  '';

  # nvim (config/nvim/lua/config/core/theme.lua) が dofile で読む
  xdg.configFile."theme/palette.lua".text = ''
    -- home/theme.nix から home-manager が生成する。編集は theme.nix 側で行うこと
    local M = {
      name = "${theme.name}",
      variant = "${theme.variant}",
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
