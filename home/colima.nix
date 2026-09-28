# コンテナランタイム: colima (Rancher Desktop 代替) をログイン時に起動する。
# docker CLI 等は packages.nix 側
{ pkgs, config, ... }:
{
  home.packages = [ pkgs.colima ];

  # KeepAlive は付けない (失敗時の再起動ループを避ける)
  launchd.agents.colima = {
    enable = true;
    config = {
      ProgramArguments = [
        "${pkgs.colima}/bin/colima"
        "start"
        "--cpu"
        "4"
        "--memory"
        "8"
      ];
      RunAtLoad = true;
      # colima の依存チェックが docker CLI を PATH から探すため、nix のプロファイルを含める
      EnvironmentVariables.PATH = "/etc/profiles/per-user/${config.home.username}/bin:/run/current-system/sw/bin:/usr/bin:/bin:/usr/sbin:/sbin";
      StandardOutPath = "${config.home.homeDirectory}/Library/Logs/colima.log";
      StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/colima.log";
    };
  };
}
