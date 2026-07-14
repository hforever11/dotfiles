# コンテナランタイム: colima (Rancher Desktop 代替) と docker CLI 周りの設定
{
  pkgs,
  lib,
  config,
  ...
}:
{
  home.packages = [ pkgs.colima ];

  # ログイン時に colima (Docker ランタイム) を起動。KeepAlive は付けない (失敗時の再起動ループを避ける)
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
      # colima の依存チェックが docker CLI (brew 管理) を PATH から探すため明示的に含める
      EnvironmentVariables.PATH = "/opt/homebrew/bin:/opt/homebrew/sbin:/etc/profiles/per-user/${config.home.username}/bin:/run/current-system/sw/bin:/usr/bin:/bin:/usr/sbin:/sbin";
      StandardOutPath = "${config.home.homeDirectory}/Library/Logs/colima.log";
      StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/colima.log";
    };
  };

  # ~/.docker/config.json は docker 自身が currentContext 等を書き換える可変ファイルなので
  # symlink では管理せず、cliPluginsExtraDirs だけ jq でマージする
  # (brew の docker-compose/docker-buildx プラグインを docker CLI に見つけさせるため)
  home.activation.dockerCliPluginsDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run mkdir -p "$HOME/.docker"
    if [ ! -s "$HOME/.docker/config.json" ]; then
      run bash -c 'echo "{}" > "$HOME/.docker/config.json"'
    fi
    run ${pkgs.jq}/bin/jq '.cliPluginsExtraDirs = ["/opt/homebrew/lib/docker/cli-plugins"]' "$HOME/.docker/config.json" > "$HOME/.docker/config.json.tmp"
    run mv "$HOME/.docker/config.json.tmp" "$HOME/.docker/config.json"
  '';
}
