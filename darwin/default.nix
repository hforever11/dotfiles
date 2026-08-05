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

  # caps_lock → right_control (旧 Karabiner の simple_modification を macOS 標準の
  # hidutil に移行)。nix-darwin の remapCapsLockToControl は left_control 固定のため
  # userKeyMapping で直接指定する。値は HID usage: 0x700000039 → 0x7000000E4
  system.keyboard = {
    enableKeyMapping = true;
    userKeyMapping = [
      {
        HIDKeyboardModifierMappingSrc = 30064771129;
        HIDKeyboardModifierMappingDst = 30064771300;
      }
    ];
  };

  # Spotlight の ⌘Space (symbolic hotkey ID 64) を無効化して Raycast に譲る。
  # CustomUserPreferences だと AppleSymbolicHotKeys 辞書全体を置き換えて
  # 他のホットキー設定を消すため、-dict-add で該当 ID のみ書き換える
  system.activationScripts.postActivation.text = ''
    sudo -u ${config.my.username} defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 '
      <dict>
        <key>enabled</key><false/>
        <key>value</key>
        <dict>
          <key>parameters</key>
          <array><integer>65535</integer><integer>49</integer><integer>1048576</integer></array>
          <key>type</key><string>standard</string>
        </dict>
      </dict>'
    sudo -u ${config.my.username} /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';

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
