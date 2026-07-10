# git のユーザー識別 (旧 config.tmpl の includeIf と users/*.gitconfig.tmpl)。
# 本体の設定は config/git/config (直リンク) 側にある
{
  lib,
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
    + lib.optionalString (git.work != null) ''
      [includeIf "gitdir:${git.work.dir}"]
        path = ~/.config/git/users/work.gitconfig
    '';

    "git/users/personal.gitconfig".text = ''
      [user]
        name = ${git.personal.name}
        email = ${git.personal.email}
    '';

    "git/users/work.gitconfig" = lib.mkIf (git.work != null) {
      text = ''
        [user]
          name = ${git.work.name}
          email = ${git.work.email}
      '';
    };
  };
}
