# mise (ランタイムマネージャ)。設定ファイルのリンクは links.nix 側
{ pkgs, lib, ... }:
{
  home.packages = [ pkgs.mise ];

  # mise のランタイムを switch 時に同期 (旧 run_onchange の mise install 相当)
  home.activation.miseInstall = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run ${pkgs.mise}/bin/mise install -y || verboseEcho "Warning: some mise runtimes failed to install"
  '';
}
