{
  # work マシンでも個人リポジトリ ("~/ghq/github.com/hforever11/") ではこの identity を使う。
  # 追加の identity は Nix 管理下に置かず hosts/work-local.gitconfig (gitignore 対象) に
  # 直接書く (home/git.nix 参照)。Nix の pure-eval は非 store 絶対パスを読めないため
  my.git.personal = {
    name = "ShoFukunaga";
    email = "squall1tfjr@gmail.com";
    dir = "~/ghq/github.com/hforever11/";
  };
}
