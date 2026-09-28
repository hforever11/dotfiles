# nixpkgs に無い / nix だと実用的でないものだけ Homebrew に置く (GUI アプリは cask)
{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      upgrade = false;
      # 宣言外の formula/cask は rebuild 時に自動削除される
      cleanup = "zap";
    };

    taps = [
      "hashicorp/tap"
      "arto-app/tap"
    ];

    brews = [
      # vault は unfree のため nix バイナリキャッシュ対象外で、nixpkgs 更新のたびに
      # 巨大な Go ソースビルドが走る。brew のバイナリ配布を使う
      "hashicorp/tap/vault"
      "libpq" # zshrc が PATH 参照 (psql/pg_config)
      "ripgrep" # nix 宣言と重複するが cask codex の brew 版依存のため維持
    ];

    casks = [
      "ghostty"
      "codex"
      "arto-app/tap/arto"
      "copilot-cli"
      "font-hackgen"
      "font-udev-gothic-nf"
      "raycast"
      "session-manager-plugin"
      "visual-studio-code"
    ];
  };
}
