#!/bin/sh

sudo apt update
sudo apt upgrade

echo "Installing apps"
sudo apt install -y \
	build-essential automake git cmake meld catfish git-cola cppcheck valgrind heaptrack heaptrack-gui \
	vim htop synaptic flameshot tilix wireshark zeal geany geany-plugins \
	exuberant-ctags cscope zip ccache curl wget default-jdk gettext python3-pip 

echo "Installing libraries"
sudo apt install -y libncurses-dev


echo "Installing Docker"

sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt -y install docker-ce docker-ce-cli containerd.io

# Add user to docker group for using docker without sudo command.
sudo groupadd docker
sudo usermod -aG docker $USER


