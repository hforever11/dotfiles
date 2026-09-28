# darwin / home-manager の両方から参照する定数
{ lib, ... }:
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
  };
}
