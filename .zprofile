# Homebrew (Apple Silicon / Intel のどちらでも)
for brew_bin in /opt/homebrew/bin/brew /usr/local/bin/brew; do
  if [ -x "$brew_bin" ]; then
    eval "$("$brew_bin" shellenv)"
    break
  fi
done
unset brew_bin

if [ -z "$SSH_AUTH_SOCK" ]; then
  # Check for a currently running instance of the agent
  RUNNING_AGENT="`ps -ax | grep 'ssh-agent -s' | grep -v grep | wc -l | tr -d '[:space:]'`"
  if [ "$RUNNING_AGENT" = "0" ]; then
    # Launch a new instance of the agent
    ssh-agent -s &> $HOME/.ssh/ssh-agent
  fi
  eval `cat $HOME/.ssh/ssh-agent`
fi

# Obsidian CLI
[ -d /Applications/Obsidian.app/Contents/MacOS ] && export PATH="$PATH:/Applications/Obsidian.app/Contents/MacOS"
