# CLI パッケージ一覧 (nixpkgs)。
# activation や launchd を伴うツールは専用モジュール側 (colima.nix / mise.nix)
{ pkgs, ... }:
{
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
    nixd
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
  ];
}
