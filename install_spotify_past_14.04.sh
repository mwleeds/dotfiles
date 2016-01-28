sudo apt-get purge spotify-client
sudo apt-get autoremove
sudo add-apt-repository --remove 'deb http://repository.spotify.com stable non-free'
sudo apt-get update
wget http://repository-origin.spotify.com/pool/non-free/s/spotify-client/spotify-client_1.0.7.153.gb9e8174a_amd64.deb
sudo dpkg -i spotify-client_1.0.7.153.gb9e8174a_amd64.deb
