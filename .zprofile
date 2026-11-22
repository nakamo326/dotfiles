# Homebrew (Apple Silicon / Intel のどちらでも)
for brew_bin in /opt/homebrew/bin/brew /usr/local/bin/brew; do
  if [ -x "$brew_bin" ]; then
    eval "$("$brew_bin" shellenv)"
    break
  fi
done
unset brew_bin

# Obsidian CLI
[ -d /Applications/Obsidian.app/Contents/MacOS ] && export PATH="$PATH:/Applications/Obsidian.app/Contents/MacOS"
