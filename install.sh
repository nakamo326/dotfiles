#!/bin/bash

curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > dein_installer.sh
# For example, we just use `~/.cache/dein` as installation directory
sh ./dein_installer.sh ~/.cache/dein


ln -s ~/dotfiles/.vimrc ~/.vimrc
ln -s ~/dotfiles/.zshrc ~/.zshrc
ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf
mkdir -p ~/.config
ln -s ~/dotfiles/starship.toml ~/.config/starship.toml

#ln -s ~/.tmux/.tmux.conf ~/.tmux.conf
# ln -s ~/dotfiles/init.vim ~/.config/nvim/init.vim

# install volta without fixing zshrc
curl https://get.volta.sh | bash -s -- --skip-setup

# install starship
curl -sS https://starship.rs/install.sh | sh

# install zoxide
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

# install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
