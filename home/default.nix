# home-manager のエントリポイント。
#   packages.nix : CLI パッケージ
#   links.nix    : config/ 等へのシンボリックリンク
#   theme.nix    : テーマ色から生成する設定ファイル
#   colima.nix / mise.nix : launchd や activation を伴うツール
{ ... }:
{
  imports = [
    ./packages.nix
    ./links.nix
    ./theme.nix
    ./colima.nix
    ./mise.nix
  ];

  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
}
