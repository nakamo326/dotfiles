#!/bin/bash
# macOS の設定。好みの設定を書き込むので、新しいマシンで一度だけ実行する想定。

# disable apple music
launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist

# disable CursorUIViewService (high CPU usage on macOS 15+, requires reboot)
# https://zenn.dev/discus0434/articles/disable-cursoruiviewservice-macos
sudo mkdir -p /Library/Preferences/FeatureFlags/Domain
sudo defaults write /Library/Preferences/FeatureFlags/Domain/UIKit.plist \
  redesigned_text_cursor -dict-add Enabled -bool NO

# スクロールバーを常に表示する
defaults write -g AppleShowScrollBars -string Always

# Dockのアイコンサイズ（16〜128の範囲で指定）
defaults write com.apple.dock tilesize -int 45

# Dockの拡大機能を有効化（true/false）
defaults write com.apple.dock magnification -bool true

# Dockの拡大時サイズ（16〜128の範囲）
defaults write com.apple.dock largesize -int 100

killall Dock


#### finder

# 隠しファイルを表示
defaults write com.apple.finder AppleShowAllFiles -bool true

# 拡張子を常に表示
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# パスバーを表示（Finder下部に現在のパスが出る）
defaults write com.apple.finder ShowPathbar -bool true

# ステータスバーを表示（容量や項目数を表示）
defaults write com.apple.finder ShowStatusBar -bool true

killall Finder
