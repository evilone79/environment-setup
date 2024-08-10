#!/bin/bash

sudo apt update
sudo apt -y upgrade

echo "Installing apps"
sudo apt install -y \
	build-essential g++ automake git cmake meld catfish cppcheck valgrind heaptrack heaptrack-gui vim htop synaptic terminator wireshark zeal exuberant-ctags cscope zip ccache curl wget default-jdk gettext \
	python3-pip apt-transport-https ca-certificates gnupg lsb-release zsh baobab gawk wget git diffstat unzip \
    texinfo chrpath socat xterm ncurses-dev lzop software-properties-common minicom adb cmake-format gdb-multiarch stlink-tools stlink-gui

echo "Installing KVM stuff"
sudo apt install -y \
    qemu-kvm qemu-system qemu-utils libvirt-clients libvirt-daemon-system bridge-utils virtinst libvirt-daemon virt-manager qemu-system-arm

echo "Installing misc libraries"
sudo apt install -y \
    libncurses-dev python3-dev libelf-dev qtbase5-dev libqt5serialport5-dev

echo "Installing Clang stuff"
sudo apt install -y \
    clang clang-tools clang-format clang-tidy

echo "Installing VimPlug"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

cp ./vimrc.tmpl ~/.vimrc
vim +'PlugInstall --sync' +qa

workdir=$(pwd)
cd ~/.vim/plugged/youcompleteme
./install.py --clangd-completer
cd $workdir

echo "Installing Docker"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt -y install docker-ce docker-ce-cli containerd.io

# Add user to docker group for using docker without sudo command.
sudo groupadd docker
sudo usermod -aG docker $USER

cp ./zshrc.tmpl ~/.zshrc
sudo chsh -s $(which zsh)

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"  "" --unattended
cp ./zshrc.tmpl ~/.zshrc




