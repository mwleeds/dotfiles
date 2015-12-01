#!/bin/bash

cp -r .vim ~
cat .bashrc >> ~/.bashrc
cat .vimrc >> ~/.vimrc
cat .gitconfig >> ~/.gitconfig
./install
