# テーマの単一ソース。palette から各ツール向けの設定ファイルを生成する。
# 生成しない (直リンクの設定に色を手書きしている) ため手動で合わせる箇所:
#   config/herdr/config.toml [theme.custom] panel_bg = mantle / text = text /
#     mauve・green・yellow・red・blue・teal・peach = 同名の色 (accent はパレット外の固定値)
#   config/delta/themes/catppuccin-latte.gitconfig file-style = text / minus 系 = red / plus 系 = green /
#     map-styles = mauve・blue・sky・yellow
{ lib, ... }:
let
  name = "catppuccin";
  variant = "latte";

  # Catppuccin Latte のマット (くすみ) 版。キー名は Catppuccin のロール名
  p = {
    # base / mantle は眩しさを抑えるため公式より二段暗い
    base = "#dce0e8";
    mantle = "#d3d8e2";
    surface0 = "#ccd0da";
    surface1 = "#bcc0cc";
    surface2 = "#acb0be";
    overlay0 = "#9ca0b0";
    subtext0 = "#6c6f85";
    subtext1 = "#5c5f77";
    # 公式 #4c4f69 より少し濃い herdr 公式サイトの実測値 (Ghostty の文字色もここから生成)
    text = "#44455d";

    # アクセントは公式の色相のまま (ずれ 5° 以内。yellow だけは暗くすると茶色に濁るため黄色寄りへ +6°)
    # OKLCH の彩度を 0.075〜0.13 に揃え、鮮やかさを抑えた。
    # 彩度を落として近づく組 (mauve と blue、peach と yellow など) は明度の差で見分けられるようにしてある。
    # green の色相は herdr の accent と同じ 146° (公式 #40a02b の 140° はライト背景だとオリーブに濁る)
    rosewater = "#bc8175";
    flamingo = "#b77473";
    pink = "#b572a2";
    mauve = "#69499c";
    red = "#a03e43";
    maroon = "#b45b63";
    peach = "#c46f49";
    yellow = "#bd8a40";
    green = "#47894f";
    teal = "#2a797c";
    sky = "#4a92bb";
    sapphire = "#3e8695";
    blue = "#416bb0";
    lavender = "#7684c6";
  };

  title = s: lib.toUpper (lib.substring 0 1 s) + lib.substring 1 (-1) s;
in
{
  # config/ghostty/config が config-file で読む
  xdg.configFile."theme/ghostty".text = ''
    # home/theme.nix から home-manager が生成する。編集は theme.nix 側で行うこと
    background = ${p.base}
    foreground = ${p.text}
    # ANSI 16 色。割り当ては Ghostty 同梱の Catppuccin Latte と同じで、bright (9〜14) は通常色と同じ値
    palette = 0=${p.subtext1}
    palette = 1=${p.red}
    palette = 2=${p.green}
    palette = 3=${p.yellow}
    palette = 4=${p.blue}
    palette = 5=${p.pink}
    palette = 6=${p.teal}
    palette = 7=${p.surface2}
    palette = 8=${p.subtext0}
    palette = 9=${p.red}
    palette = 10=${p.green}
    palette = 11=${p.yellow}
    palette = 12=${p.blue}
    palette = 13=${p.pink}
    palette = 14=${p.teal}
    palette = 15=${p.surface1}
  '';

  # 色だけを置く。レイアウト等の色以外の指定は config/zsh/.zshenv の FZF_DEFAULT_OPTS
  xdg.configFile."fzf/config".text = ''
    # home/theme.nix から home-manager が生成する。編集は theme.nix 側で行うこと
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

  # claude statusline (claude/statusline.sh) が source で読む
  xdg.configFile."theme/palette.sh".text = ''
    # home/theme.nix から home-manager が生成する。編集は theme.nix 側で行うこと
    ${lib.concatStringsSep "\n" (lib.mapAttrsToList (n: v: "THEME_${lib.toUpper n}=\"${v}\"") p)}
  '';

  # Claude Code のカスタムテーマ。claude/settings.json の "theme": "custom:dotfiles" で選ぶ。
  # light を土台に、鮮やかな色 (OKLCH の彩度 0.14 超) を同じ役割のパレットの色に置き換える。
  # サブエージェントの 8 色と ultrathink の虹色 7 色は、組で揃うよう全部置き換える。
  # 差分の色 (diff*) は置き換えない。diffAddedWord は「+12 -3 の数字の色」と「差分の単語ハイライトの背景」を
  # 兼ねていて、数字が読める濃さにするとハイライト上のコードが読めなくなるため。上書きしなければ差分は
  # Claude Code 内蔵の配色で描かれ、数字は light の #2f9d44 になる (herdr の accent はこの色に合わせている)
  home.file.".claude/themes/dotfiles.json".text = builtins.toJSON {
    name = "Catppuccin ${title variant} (dotfiles)";
    base = "light";
    overrides = {
      error = p.red;
      permission = p.blue;
      permissionShimmer = p.lavender;
      suggestion = p.blue;
      remember = p.blue;
      briefLabelYou = p.blue;
      rate_limit_fill = p.blue;
      claudeBlue_FOR_SYSTEM_SPINNER = p.blue;
      claudeBlueShimmer_FOR_SYSTEM_SPINNER = p.lavender;
      autoAccept = p.mauve;
      skill = p.mauve;
      merged = p.mauve;
      effortUltra = p.mauve;
      bashBorder = p.pink;
      fastMode = p.peach;
      fastModeShimmer = p.yellow;
      chromeYellow = p.yellow;

      red_FOR_SUBAGENTS_ONLY = p.red;
      orange_FOR_SUBAGENTS_ONLY = p.peach;
      yellow_FOR_SUBAGENTS_ONLY = p.yellow;
      green_FOR_SUBAGENTS_ONLY = p.green;
      cyan_FOR_SUBAGENTS_ONLY = p.sapphire;
      blue_FOR_SUBAGENTS_ONLY = p.blue;
      purple_FOR_SUBAGENTS_ONLY = p.mauve;
      pink_FOR_SUBAGENTS_ONLY = p.pink;

      rainbow_red = p.maroon;
      rainbow_orange = p.peach;
      rainbow_yellow = p.yellow;
      rainbow_green = p.green;
      rainbow_blue = p.sky;
      rainbow_indigo = p.lavender;
      rainbow_violet = p.pink;
    };
  };
}
