{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [ ./homebrew.nix ];

  # Nix 本体 (デーモン・GC・設定) は Determinate Nix が管理する
  nix.enable = false;

  nixpkgs.hostPlatform = "aarch64-darwin";

  # vault は BSL ライセンスのため個別許可
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "vault"
    ];

  system.stateVersion = 6;
  system.primaryUser = config.my.username;

  users.users.${config.my.username}.home = "/Users/${config.my.username}";

  # /etc/zshenv 等に Nix のパス設定を書き込む
  programs.zsh.enable = true;

  # 旧 cask: font-hackgen-nerd, font-maple-mono-nf
  fonts.packages = [
    pkgs.hackgen-nf-font
    pkgs.maple-mono.NF
  ];
}
