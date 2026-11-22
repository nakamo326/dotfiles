#!/bin/bash
# リモートの変更を取り込んでこのマシンに適用する。
set -eu

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
cd "$DOTFILES"

before=$(git rev-parse HEAD)
git pull --ff-only
after=$(git rev-parse HEAD)

if [ "$before" != "$after" ]; then
  git --no-pager log --oneline "$before..$after"
fi

"$DOTFILES/link.sh"

if git diff --quiet "$before" "$after" -- Brewfile; then
  echo "Brewfile に変更なし: brew bundle はスキップ"
else
  brew bundle --file="$DOTFILES/Brewfile"
fi

echo "完了。シェル設定の変更は 'exec zsh' で反映されます。"
