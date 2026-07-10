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

  security.pam.services.sudo_local.touchIdAuth = true;

  system.defaults = {
    dock = {
      autohide = true;
      show-recents = false;
      tilesize = 48;
    };

    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      ShowPathbar = true;
      FXPreferredViewStyle = "Nlsv"; # リスト表示
    };

    NSGlobalDomain = {
      KeyRepeat = 2;
      InitialKeyRepeat = 15;
    };

    trackpad = {
      Clicking = true; # tap-to-click
      TrackpadThreeFingerDrag = true;
    };
  };
}
