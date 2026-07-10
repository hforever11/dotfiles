# nixpkgs に無いものだけ Homebrew に残す (旧 Brewfile)
{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      upgrade = false;
      # Brewfile 外の手動インストール分 (docker, rustup, imagemagick 等) が
      # まだ brew 管理で残っているため、棚卸しが終わるまで cleanup しない。
      # Phase 3 完了後に "zap" へ変更する
      cleanup = "none";
    };

    brews = [
      "hunk" # nixpkgs 未収録 (レビュー特化 diff ビューア)
    ];

    casks = [
      "ghostty"
      "codex"
    ];
  };
}
