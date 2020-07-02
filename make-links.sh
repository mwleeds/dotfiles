#!/bin/bash

ln -sf ~/Desktop/dotfiles/.gdbinit ~/.gdbinit
ln -sf ~/Desktop/dotfiles/.gitconfig ~/.gitconfig
ln -sf ~/Desktop/dotfiles/.gitignore_global ~/.gitignore_global
ln -sf ~/Desktop/dotfiles/.vimrc ~/.vimrc
mkdir -p ~/.config/nvim
ln -sf ~/.vimrc ~/.config/nvim/init.vim
ln -sf ~/Desktop/dotfiles/.git-completion.bash ~/.git-completion.bash
ln -sf ~/Desktop/dotfiles/.bashrc ~/.bashrc
ln -sf ~/Desktop/dotfiles/.Xmodmap ~/.Xmodmap
ln -sf ~/Desktop/dotfiles/.inputrc ~/.inputrc
rm -rf ~/.vim && mkdir ~/.vim
ln -sf ~/Desktop/dotfiles/.vim/plugin ~/.vim
ln -sf ~/Desktop/dotfiles/.vim/doc ~/.vim

mkdir -p ~/.local/bin/
test -e ~/.local/bin/back.sh || ln -s ~/Desktop/dotfiles/scripts/back.sh ~/.local/bin/
test -e ~/.local/bin/diff-so-fancy || ln -s ~/Desktop/dotfiles/scripts/diff-so-fancy ~/.local/bin/
test -e ~/.local/bin/git-superfixup.pl || ln -s ~/Desktop/dotfiles/scripts/git-superfixup.pl ~/.local/bin/
test -e ~/.local/bin/clone_all_repos.sh || ln -s ~/Desktop/dotfiles/scripts/clone_all_repos.sh ~/.local/bin/

mkdir -p ~/.config/gtk-3.0
ln -sf ~/Desktop/dotfiles/.config/gtk-3.0/gtk.css ~/.config/gtk-3.0/
