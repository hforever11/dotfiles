# home-manager のエントリポイント。設定の実体は関心ごとの各モジュール側
{ ... }:
{
  imports = [
    ./packages.nix
    ./links.nix
    ./generated.nix
    ./git.nix
    ./colima.nix
    ./mise.nix
  ];

  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
}
