# dotfiles

macOS 用の dotfiles。

## 新しいマシンで

```sh
git clone https://github.com/nakamo326/dotfiles_mac.git ~/dotfiles
~/dotfiles/install.sh   # Homebrew・パッケージ・リンク・mise のツール
~/dotfiles/macos.sh     # macOS の設定（任意）
```

## 他のマシンでの変更を取り込む

```sh
dotup   # = ~/dotfiles/update.sh
```

pull、リンクの張り直し、`Brewfile` に変更があれば `brew bundle` まで行う。

## 構成

| ファイル | 役割 |
|---|---|
| `install.sh` | 初期セットアップ（何度実行しても安全） |
| `macos.sh` | macOS の設定 |
| `update.sh` | リモートの変更を取り込んで適用 |
| `link.sh` | シンボリックリンクを張る。管理対象を増やすときはここに追記 |
| `Brewfile` | Homebrew のパッケージ |
| `mise/config.toml` | 言語・ツールのバージョン |

- ホーム側に実ファイルがある場合、`link.sh` は上書きせずに警告を出す。中身を確認して退避してから再実行する。
- マシン固有の設定は `~/.zshrc.local` に書く（git 管理外）。
