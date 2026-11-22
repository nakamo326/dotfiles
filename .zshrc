# ────────────────────────────────────────────────────────────────
# 🚀 Zinit Plugin Manager のインストーラー & 初期設定
# ────────────────────────────────────────────────────────────────
### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

# Zinit 本体読み込み
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Annexes（追加プラグイン）を light モードで読み込み
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# プラグイン読み込み（light モード / スニペット）
zinit light zsh-users/zsh-autosuggestions
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit snippet OMZ::lib/git.zsh
zinit snippet OMZ::plugins/git/git.plugin.zsh

# ────────────────────────────────────────────────────────────────
# 📖 コマンド履歴オプション設定
# ────────────────────────────────────────────────────────────────
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt share_history
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks

# ────────────────────────────────────────────────────────────────
# 🛠️ Zsh オプション設定
# ────────────────────────────────────────────────────────────────
# Emacs キーバインド
bindkey -e

setopt auto_list
setopt auto_menu
setopt auto_cd
setopt nonomatch
setopt autopushd
setopt pushdignoredups

# 補完操作のビジュアルチューニング
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# ────────────────────────────────────────────────────────────────
# 🌈 カラー設定 & ビルドフラグ
# ────────────────────────────────────────────────────────────────
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
export MAKEFLAGS=-j$(sysctl -n hw.ncpu)

# ────────────────────────────────────────────────────────────────
# 🔗 エイリアス集
# ────────────────────────────────────────────────────────────────
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias wo='cd ~/workspace'
alias ls='eza --icons --git --time-style relative'
alias la='eza --icons --git --time-style relative -a'
alias lla='eza --icons --git --time-style relative -al'
alias cat='bat'
alias tf='terraform'
alias dotup='~/dotfiles/update.sh'

# ────────────────────────────────────────────────────────────────
# 📂 PATH カスタマイズ
# ────────────────────────────────────────────────────────────────
# Homebrew（shellenv は .zprofile で実行済み）
[ -n "$HOMEBREW_PREFIX" ] && export LIBRARY_PATH="$LIBRARY_PATH:$HOMEBREW_PREFIX/lib"

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# ────────────────────────────────────────────────────────────────
# 🛠️ ツールの初期化
# ────────────────────────────────────────────────────────────────
# mise
command -v mise >/dev/null && eval "$(mise activate zsh)"

# zoxide
eval "$(zoxide init --cmd cd zsh)"
unalias zi

# fzf
source <(fzf --zsh)

# starship
eval "$(starship init zsh)"

# ────────────────────────────────────────────────────────────────
# ⌨️ 補完システム初期化
# ────────────────────────────────────────────────────────────────

# initialization of zsh completion system
autoload -Uz compinit
compinit

autoload -Uz +X bashcompinit && bashcompinit

# load completions

## kubectl
command -v kubectl >/dev/null && source <(kubectl completion zsh)

## terraform
command -v terraform >/dev/null && complete -o nospace -C "$(command -v terraform)" terraform

## docker
command -v docker >/dev/null && source <(docker completion zsh)

# ────────────────────────────────────────────────────────────────
# 🏠 マシン固有の設定（git 管理外）
# ────────────────────────────────────────────────────────────────
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
