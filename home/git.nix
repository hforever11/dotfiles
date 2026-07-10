# git のユーザー識別 (旧 config.tmpl の includeIf と users/*.gitconfig.tmpl)。
# 本体の設定は config/git/config (直リンク) 側にある
{
  config,
  osConfig,
  ...
}:
let
  inherit (osConfig.my) git dotfilesDir;
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/${path}";
in
{
  xdg.configFile = {
    "git/config".source = link "config/git/config";
    "git/ignore".source = link "config/git/ignore";

    "git/identity.gitconfig".text = ''
      [includeIf "gitdir:${git.personal.dir}"]
        path = ~/.config/git/users/personal.gitconfig
    ''
    + ''
      [includeIf "gitdir:${dotfilesDir}/"]
        path = ~/.config/git/dotfiles-repo.gitconfig
    ''
    # 追加の identity は Nix の pure-eval からは読めない (builtins.pathExists / getEnv は
    # 非 store 絶対パスに対して常に false/空文字を返す)ため、Nix で値を扱わず実ファイル
    # システム上の gitconfig を直接 include する。無ければ git が黙って無視する
    + ''
      [include]
        path = ~/.config/git/work-local.gitconfig
    '';

    # dotfiles リポジトリ限定で pre-commit フックを有効化 (nixfmt --check)
    "git/dotfiles-repo.gitconfig".text = ''
      [core]
        hooksPath = ${dotfilesDir}/.githooks
    '';

    "git/users/personal.gitconfig".text = ''
      [user]
        name = ${git.personal.name}
        email = ${git.personal.email}
    '';

    # includeIf + user 情報は hosts/work-local.gitconfig (gitignore 対象) に直接書く。
    # 無ければ直リンクが dangling symlink になり、上の [include] が黙って無視する
    "git/work-local.gitconfig".source = link "hosts/work-local.gitconfig";
  };
}
