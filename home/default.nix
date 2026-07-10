{ pkgs, lib, ... }:
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
    tmux # fallback (メインは herdr に移行済み)
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
  ];

  # mise のランタイムを switch 時に同期 (旧 run_onchange の mise install 相当)
  home.activation.miseInstall = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run ${pkgs.mise}/bin/mise install -y || verboseEcho "Warning: some mise runtimes failed to install"
  '';
}
