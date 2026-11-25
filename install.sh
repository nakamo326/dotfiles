#!/bin/bash
# 新しいマシンの初期セットアップ（macOS / Linux）。何度実行しても安全。
set -eu

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
OS="$(uname -s)"

mkdir -p ~/workspace

# Linux: Homebrew の前提パッケージと zsh（Debian / Ubuntu 系を想定）
if [ "$OS" = Linux ]; then
  if command -v apt-get >/dev/null; then
    sudo apt-get update
    sudo apt-get install -y build-essential procps curl file git zsh unzip fontconfig
  else
    echo "apt-get がありません。build-essential 相当・curl・git・zsh を手動で入れてから再実行してください" >&2
  fi
fi

# Homebrew
if ! command -v brew >/dev/null; then
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
for brew_bin in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
  [ -x "$brew_bin" ] && eval "$("$brew_bin" shellenv)" && break
done
brew update
brew bundle --file="$DOTFILES/Brewfile"

# シンボリックリンク
"$DOTFILES/link.sh"

# mise で管理する言語・ツール
mise install

if [ "$OS" = Linux ]; then
  # HackGen Nerd Font（macOS では Brewfile の cask で入る）
  if ! fc-list | grep -q "HackGen Console NF"; then
    url=$(curl -fsSL https://api.github.com/repos/yuru7/HackGen/releases/latest \
      | jq -r '.assets[] | select(.name | test("^HackGen_NF_v.*\\.zip$")) | .browser_download_url')
    tmp=$(mktemp -d)
    curl -fsSL -o "$tmp/hackgen.zip" "$url"
    unzip -q -o "$tmp/hackgen.zip" -d "$tmp"
    mkdir -p ~/.local/share/fonts/HackGen
    find "$tmp" -name '*.ttf' -exec cp {} ~/.local/share/fonts/HackGen/ \;
    fc-cache -f >/dev/null
    rm -rf "$tmp"
    echo "HackGen Nerd Font をインストールしました"
  fi

  # ログインシェルを zsh に
  zsh_path="$(command -v zsh)"
  if [ "$(getent passwd "$USER" | cut -d: -f7)" != "$zsh_path" ]; then
    sudo chsh -s "$zsh_path" "$USER" || echo "chsh に失敗しました。手動で 'chsh -s $zsh_path' を実行してください" >&2
  fi

  echo "完了。再ログインすると zsh が使えます。"
else
  echo "完了。macOS の設定も入れる場合は $DOTFILES/macos.sh を実行してください。"
fi
