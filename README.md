# dotfiles

macOS / Linux（Debian・Ubuntu 系）用の dotfiles。

## 新しいマシンで

```sh
git clone https://github.com/nakamo326/dotfiles_mac.git ~/dotfiles
~/dotfiles/install.sh   # Homebrew・パッケージ・リンク・mise のツール
~/dotfiles/macos.sh     # macOS の設定（任意。macOS のみ）
```

### Linux の場合

`install.sh` は追加で次を行う。

- apt で Homebrew の前提パッケージと zsh を入れ、ログインシェルを zsh に変える
- HackGen Nerd Font を `~/.local/share/fonts` に入れる
- GitHub の認証は `gh` を使うので、セットアップ後に `gh auth login` を実行する

GUI アプリ（Ghostty・Zed など）と Docker は `Brewfile` では macOS のみ。Linux では各公式の手順で入れる（設定ファイルのリンクは共通）。

## 他のマシンでの変更を取り込む

```sh
dotup   # = ~/dotfiles/update.sh
```

pull、リンクの張り直し、`Brewfile` に変更があれば `brew bundle` まで行う。

## 構成

| ファイル | 役割 |
|---|---|
| `install.sh` | 初期セットアップ（何度実行しても安全） |
| `macos.sh` | macOS の設定（Linux では何もしない） |
| `update.sh` | リモートの変更を取り込んで適用 |
| `link.sh` | シンボリックリンクを張る。管理対象を増やすときはここに追記 |
| `Brewfile` | Homebrew のパッケージ（`if OS.mac?` の中は macOS のみ） |
| `git/{macos,linux}.gitconfig` | OS ごとの git 設定（認証ヘルパーなど）。`.gitconfig` から include |
| `mise/config.toml` | 言語・ツールのバージョン |

- ホーム側に実ファイルがある場合、`link.sh` は上書きせずに警告を出す。中身を確認して退避してから再実行する。
- OS で分岐が必要なものは `link.sh` / `install.sh` の中で `uname` を見て切り替える。
- マシン固有の設定は `~/.zshrc.local` に書く（git 管理外）。
