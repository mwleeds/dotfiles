#!/bin/bash

# install official packages
sudo apt-get install python3 vim sl openssh-server clang gimp vlc chromium git build-essential npm nodejs pdftk tree iotop htop gparted screen curl npm ghc mit-scheme valgrind traceroute fail2ban

# remove stuff
#sudo apt-get remove --purge unity-lens-shopping update-manager

# install spotify (on 14.04)
#sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys D2C19886
#echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
#sudo apt-get install spotify-client

# install spotify (past 14.04)
#sudo apt-get purge spotify-client
#sudo apt-get autoremove
#sudo add-apt-repository --remove 'deb http://repository.spotify.com stable non-free'
#sudo apt-get update
#wget http://repository-origin.spotify.com/pool/non-free/s/spotify-client/spotify-client_1.0.7.153.gb9e8174a_amd64.deb
#sudo dpkg -i spotify-client_1.0.7.153.gb9e8174a_amd64.deb
