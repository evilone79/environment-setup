#!/bin/bash

sudo apt update
sudo apt -y upgrade

echo "Installing apps"
sudo apt install -y \
    build-essential g++ automake git cmake meld catfish cppcheck valgrind heaptrack heaptrack-gui vim htop synaptic wireshark zeal universal-ctags cscope zip ccache curl wget default-jdk gettext \
    python3-pip apt-transport-https ca-certificates gnupg lsb-release zsh baobab gawk wget git diffstat unzip \
    texinfo chrpath socat xterm libncurses-dev lzop software-properties-common minicom adb cmake-format gdb-multiarch stlink-tools stlink-gui bison flex

echo "Installing KVM stuff"
sudo apt install -y \
    qemu-kvm qemu-system qemu-utils libvirt-clients libvirt-daemon-system bridge-utils virt-manager qemu-system-arm

# Optional: Add user to groups for non-root KVM/Docker access (requires re-login)
sudo usermod -aG kvm $USER
sudo usermod -aG libvirt $USER

echo "Installing misc libraries"
sudo apt install -y \
    libncurses-dev python3-dev libelf-dev qtbase5-dev libqt5serialport5-dev libssl-dev

echo "Installing Clang stuff"
sudo apt install -y \
    clang clang-tools clang-format clang-tidy

echo "Installing VimPlug and YouCompleteMe"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

cp ./vimrc.tmpl ~/.vimrc

# Run Vim to install plugins (non-interactive)
vim -Es -u ~/.vimrc -c "PlugInstall --sync" -c "qa!"

# Install YCM with clangd support (adjust path if your VimPlug uses different dir)
# Modern VimPlug default: ~/.vim/pack/plugins/start/YouCompleteMe
# If your vimrc sets opt or different, adjust accordingly
if [ -d "~/.vim/pack/plugins/start/youcompleteme" ]; then
    cd ~/.vim/pack/plugins/start/youcompleteme
elif [ -d "~/.vim/plugged/youcompleteme" ]; then
    cd ~/.vim/plugged/youcompleteme
else
    echo "YouCompleteMe directory not found! Check VimPlug installation."
    exit 1
fi

python3 install.py --clangd-completer
cd -

echo "Installing Docker (official current method)"
# Prerequisites (already installed earlier: ca-certificates curl gnupg lsb-release)

sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt -y install docker-ce docker-ce-cli containerd.io

# Add user to docker group (no sudo needed for docker)
sudo usermod -aG docker $USER

echo "Setting up Zsh and Oh My Zsh"
cp ./zshrc.tmpl ~/.zshrc

sudo chsh -s $(which zsh) $USER

# Install Oh My Zsh unattended (won't change shell again or run zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

echo "Installation complete!"
echo "Note: Re-login or run 'newgrp docker' / 'newgrp libvirt' for group changes to take effect."
echo "A new terminal/session will use Zsh by default after re-login."
