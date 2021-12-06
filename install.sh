#install zplug
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
#install tmux-configure
#git clone --recursive https://github.com/tony/tmux-config.git ~/.tmux
#ln -s ~/.tmux/.tmux.conf ~/.tmux.conf
#git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

ln -s ~/dotfiles/.vimrc ~/.vimrc
ln -s ~/dotfiles/.zshrc ~/.zshrc
ln -s ~/dotfiles/init.vim ~/.config/nvim/init.vim
