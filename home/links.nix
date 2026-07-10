# リポジトリへの直リンク (編集が即反映される。rebuild 不要)。
# テーマ・ホスト依存の生成物は generated.nix / git.nix 側
{ config, osConfig, ... }:
let
  inherit (osConfig.my) dotfilesDir;
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/${path}";
in
{
  # zsh の起動チェーン入口。ZDOTDIR を設定して XDG 側の .zshenv へ繋ぐ
  home.file.".zshenv".text = ''
    # Zsh config directory
    # ZDOTDIR をここで設定しても zsh は $ZDOTDIR/.zshenv に戻らないため、明示的に source する。
    # (ZDOTDIR が事前に設定済みの環境では zsh が直接 $ZDOTDIR/.zshenv を読み、このファイルは読まれない)
    export ZDOTDIR="''${ZDOTDIR:-$HOME/.config/zsh}"
    [ -f "$ZDOTDIR/.zshenv" ] && source "$ZDOTDIR/.zshenv"
  '';

  xdg.configFile = {
    "bat".source = link "config/bat";
    "delta".source = link "config/delta";
    "ghostty".source = link "config/ghostty";
    # herdr は同ディレクトリに session.json / ログ / ソケットを書くため、ファイル単位でリンクする
    "herdr/config.toml".source = link "config/herdr/config.toml";
    "lazygit".source = link "config/lazygit";
    "mise".source = link "config/mise";
    "nvim".source = link "config/nvim";
    "sheldon".source = link "config/sheldon";
    "starship".source = link "config/starship";
    "zsh".source = link "config/zsh";
    "zsh-abbr".source = link "config/zsh-abbr";
    "claude/statusline.sh".source = link "config/claude/statusline.sh";
  };

  home.file = {
    # ~/.claude はランタイム状態を含むため、管理対象のサブディレクトリだけリンクする
    ".claude/agents".source = link "claude/agents";
    ".claude/hooks".source = link "claude/hooks";
    ".claude/skills".source = link "claude/skills";

    ".local/bin/git-unlock".source = link "bin/git-unlock";
    ".local/bin/herdr-navigate".source = link "bin/herdr-navigate";
    ".local/bin/lazygit-guard".source = link "bin/lazygit-guard";
  };
}
