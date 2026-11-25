#!/bin/bash
# dotfiles のシンボリックリンクを張る。何度実行しても安全（冪等）。
# 既存の実ファイルは上書きせず警告だけ出す。
set -u

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

case "$(uname -s)" in
  Darwin) OS=macos ;;
  *)      OS=linux ;;
esac

link() {
  local src="$DOTFILES/$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -L "$dst" ]; then
    [ "$(readlink "$dst")" = "$src" ] && return
    ln -sfn "$src" "$dst" && echo "relinked: $dst -> $src"
  elif [ -e "$dst" ]; then
    echo "skip (実ファイルがあります。確認して退避後に再実行): $dst" >&2
  else
    ln -s "$src" "$dst" && echo "linked:   $dst -> $src"
  fi
}

link .vimrc                  ~/.vimrc
link .zshrc                  ~/.zshrc
link .zprofile               ~/.zprofile
link .gitconfig              ~/.gitconfig
link starship.toml           ~/.config/starship.toml
link ghostty/config          ~/.config/ghostty/config
link mise/config.toml        ~/.config/mise/config.toml
link git/$OS.gitconfig       ~/.config/git/os.gitconfig
link agents/.skill-lock.json ~/.agents/.skill-lock.json

# 自作エージェントスキル（Claude Code 用）
link agents/skills/gemini-advisor-sensor ~/.claude/skills/gemini-advisor-sensor
link zed/settings.json       ~/.config/zed/settings.json

# lazygit は OS ごとに設定ファイルの場所が違う
if [ "$OS" = macos ]; then
  link lazygit/config.yml ~/Library/Application\ Support/lazygit/config.yml
else
  link lazygit/config.yml ~/.config/lazygit/config.yml
fi

# docker CLI プラグイン（Homebrew の compose / buildx を docker から使えるようにする）
if command -v brew >/dev/null; then
  for plugin in docker-compose docker-buildx; do
    bin="$(brew --prefix)/opt/$plugin/bin/$plugin"
    dst="$HOME/.docker/cli-plugins/$plugin"
    if [ -x "$bin" ] && [ "$(readlink "$dst" 2>/dev/null)" != "$bin" ]; then
      mkdir -p "$(dirname "$dst")"
      ln -sfn "$bin" "$dst" && echo "linked:   $dst -> $bin"
    fi
  done
fi
