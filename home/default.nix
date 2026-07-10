{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ./links.nix
    ./generated.nix
    ./git.nix
  ];

  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # ===== Core tools =====
    git
    gh
    neovim
    herdr
    starship
    sheldon
    fzf
    ripgrep
    fd
    bat
    eza
    zoxide
    lazygit
    ghq
    jq
    yq-go # brew "yq" と同じ mikefarah 版
    tree
    tree-sitter
    mise
    delta
    direnv
    pokemon-colorscripts

    # ===== Development =====
    protobuf
    grpcurl
    mkcert
    nixfmt
    ast-grep
    # nvim (lsp/conform) が参照
    lua-language-server
    stylua
    ruff
    luarocks

    # ===== Kubernetes / Infrastructure =====
    tenv
    k9s
    fluxcd
    talosctl
    argocd
    kind
    kustomize
    cosign
    cloudflared
    dnsmasq
    kubectl
    kubernetes-helm

    # ===== Container runtime (Rancher Desktop 代替) =====
    colima
  ];

  # mise のランタイムを switch 時に同期 (旧 run_onchange の mise install 相当)
  home.activation.miseInstall = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run ${pkgs.mise}/bin/mise install -y || verboseEcho "Warning: some mise runtimes failed to install"
  '';

  # ログイン時に colima (Docker ランタイム) を起動。KeepAlive は付けない (失敗時の再起動ループを避ける)
  launchd.agents.colima = {
    enable = true;
    config = {
      ProgramArguments = [
        "${pkgs.colima}/bin/colima"
        "start"
      ];
      RunAtLoad = true;
      # colima の依存チェックが docker CLI (brew 管理) を PATH から探すため明示的に含める
      EnvironmentVariables.PATH = "/opt/homebrew/bin:/opt/homebrew/sbin:/etc/profiles/per-user/${config.home.username}/bin:/run/current-system/sw/bin:/usr/bin:/bin:/usr/sbin:/sbin";
      StandardOutPath = "${config.home.homeDirectory}/Library/Logs/colima.log";
      StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/colima.log";
    };
  };
}
