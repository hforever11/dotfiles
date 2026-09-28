# dotfiles (nix-darwin + home-manager)

構成と運用は [README.md](README.md) と [docs/nix.md](docs/nix.md) を参照。作業時の注意点:

- `config/` `bin/` `claude/` は直リンク。編集は保存した瞬間に実環境へ反映される (rebuild 不要)。
  `claude/settings.json` は Claude Code 自身の設定 (権限ルールを含む) なので、変更はユーザーに確認してから行う
- `.nix` の変更は rebuild で反映される。`sudo darwin-rebuild switch --flake .#mac` は sudo が要るのでユーザーに実行を頼む
- rebuild 前の検証は `nix build .#darwinConfigurations.mac.system -o <一時パス>` (sudo 不要)
- flake は git 管理下のファイルしか見ない。新しい `.nix` ファイルは `git add` してから評価する
- `.nix` は nixfmt で整形する (pre-commit が `nixfmt --check` する)
- 仕事用マシンでの FOD のハッシュ不一致は ESET が原因。ハッシュを書き換えて回避しない
- マシン固有の git identity は `config/git/*.local.gitconfig` (gitignore)。中身をコミットや出力に含めない
