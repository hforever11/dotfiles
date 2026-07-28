# nixpkgs に無いものだけ Homebrew に残す (旧 Brewfile)
{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      upgrade = false;
      # 棚卸し完了 (2026-07-10)。宣言外の formula/cask は rebuild 時に自動削除される
      cleanup = "zap";
    };

    taps = [
      "hashicorp/tap"
      "arto-app/tap"
    ];

    brews = [
      "hunk" # nixpkgs 未収録 (レビュー特化 diff ビューア)
      # vault は unfree のため nix バイナリキャッシュ対象外で、nixpkgs 更新のたびに
      # 巨大な Go ソースビルドが走る。brew のバイナリ配布を使う
      "hashicorp/tap/vault"
      "libpq" # zshrc が PATH 参照 (psql/pg_config)
      "ripgrep" # nix 宣言と重複するが cask codex の brew 版依存のため維持
      "docker"
      "docker-completion" # docker の zsh 補完 (upstream 非推奨だが代替が出るまで維持)
      "docker-compose"
      "docker-buildx"
      "docker-credential-helper"
      "podman"
      "lazydocker"
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
