# ホストごとの可変値 (旧 chezmoi の promptStringOnce / machine_type に相当)
{ lib, ... }:
let
  gitIdentity = lib.types.submodule {
    options = {
      name = lib.mkOption { type = lib.types.str; };
      email = lib.mkOption { type = lib.types.str; };
      # includeIf "gitdir:..." に使うため末尾スラッシュ必須
      dir = lib.mkOption { type = lib.types.str; };
    };
  };
in
{
  options.my = {
    username = lib.mkOption {
      type = lib.types.str;
      default = "sfukunaga";
    };

    # mkOutOfStoreSymlink のリンク先。リポジトリを移動したらここだけ変える
    dotfilesDir = lib.mkOption {
      type = lib.types.str;
      default = "/Users/sfukunaga/ghq/github.com/hforever11/dotfiles";
    };

    git.personal = lib.mkOption { type = gitIdentity; };
  };
}
