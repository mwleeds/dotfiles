#!/bin/bash

ln -sf ~/Desktop/dotfiles/.gdbinit ~/.gdbinit
ln -sf ~/Desktop/dotfiles/.gitconfig ~/.gitconfig
ln -sf ~/Desktop/dotfiles/.vimrc ~/.vimrc
ln -sf ~/Desktop/dotfiles/.jhbuildrc ~/.jhbuildrc
ln -sf ~/Desktop/dotfiles/.git-completion.bash ~/.git-completion.bash
ln -sf ~/Desktop/dotfiles/.bashrc ~/.bashrc
ln -sf ~/Desktop/dotfiles/.Xmodmap ~/.Xmodmap
rm -rf ~/.vim && mkdir ~/.vim
ln -sf ~/Desktop/dotfiles/.vim/plugin ~/.vim
ln -sf ~/Desktop/dotfiles/.vim/doc ~/.vim

test -e /usr/local/bin/back.sh || sudo ln -s ~/Desktop/dotfiles/scripts/back.sh /usr/local/bin/
test -e /usr/local/bin/diff-so-fancy || sudo ln -s ~/Desktop/dotfiles/scripts/diff-so-fancy /usr/local/bin/

mkdir -p ~/.config/gtk-3.0
ln -sf ~/Desktop/dotfiles/.config/gtk-3.0/settings.ini ~/.config/gtk-3.0/
ln -sf ~/Desktop/dotfiles/.config/gtk-3.0/gtk.css ~/.config/gtk-3.0/

mkdir -p ~/.local/share/gnome-shell
rm -rf ~/.local/share/gnome-shell/extensions
ln -sf ~/Desktop/dotfiles/.local/share/gnome-shell/extensions ~/.local/share/gnome-shell/extensions

