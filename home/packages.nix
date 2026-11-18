# CLI パッケージ一覧 (nixpkgs)。
# launchd や activation を伴うツールだけは専用モジュール側 (colima.nix / mise.nix)
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
    # markdown / yaml の整形。CJK を 2 桁幅で計算するためテーブルが端末上で揃う
    # (nodePackages は 2026-03-03 に nixpkgs から削除済み。トップレベルを使う)
    prettier
    # シェルスクリプトの検査と整形。shfmt は nvim (conform) も参照する
    shellcheck
    shfmt
    # Go。gopls は Claude Code の gopls-lsp プラグインが PATH から探す (nvim は Mason の gopls を使う)。
    # gofumpt と gotools (goimports) は nvim (conform) が参照する
    gopls
    gofumpt
    gotools
    # コミット前の秘密情報の検査 (.githooks/pre-commit)
    gitleaks

    # ===== Containers =====
    # ランタイムは colima (colima.nix)。docker は buildx / compose プラグインと zsh 補完を同梱する
    docker
    docker-credential-helpers # credsStore = osxkeychain
    lazydocker

    # ===== Kubernetes / Infrastructure =====
    # tofu は mise 管理 (config/mise/config.toml)
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
