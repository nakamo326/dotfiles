#!/bin/bash
# 新しいマシンの初期セットアップ。何度実行しても安全。
set -eu

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

mkdir -p ~/workspace

# Homebrew
if ! command -v brew >/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
for brew_bin in /opt/homebrew/bin/brew /usr/local/bin/brew; do
  [ -x "$brew_bin" ] && eval "$("$brew_bin" shellenv)" && break
done
brew update
brew bundle --file="$DOTFILES/Brewfile"

# シンボリックリンク
"$DOTFILES/link.sh"

# mise で管理する言語・ツール
mise install

echo "完了。macOS の設定も入れる場合は $DOTFILES/macos.sh を実行してください。"
