#!/bin/sh

sudo dnf update -y
sudo dnf upgrade -y

echo "Installing apps"
sudo dnf install -y \
    @development-tools gcc-c++ automake cmake meld catfish cppcheck valgrind heaptrack vim \
    htop flameshot tilix wireshark zeal geany \
    ctags cscope zip ccache curl wget java-latest-openjdk gettext python3-pip \
    dnf-plugins-core ca-certificates gnupg2 zsh baobab clang clang-tools-extra bear \
    gawk texinfo chrpath socat xterm lzop elfutils-libelf-devel


workdir=$(pwd)

if [[ ! -f /usr/local/bin/btop ]]; then
    wget https://github.com/aristocratos/btop/releases/download/v1.3.2/btop-x86_64-linux-musl.tbz
    tar -xvf btop-x86_64-linux-musl.tbz
    cd btop
    sudo make install
    sudo make setuid
    cd $workdir
fi


echo "Installing libraries"
sudo dnf install -y ncurses-devel python3-devel

echo "Installing VimPlug"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

cp ./vimrc.tmpl ~/.vimrc
vim +'PlugInstall --sync' +qa

cd ~/.vim/plugged/youcompleteme
./install.py --clangd-completer
cd $workdir

echo "Installing Docker"
sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo

sudo dnf update -y
sudo dnf install -y docker-ce docker-ce-cli containerd.io

# Add user to docker group for using docker without sudo command.
sudo groupadd docker
sudo usermod -aG docker $USER
sudo systemctl start docker

cp ./zshrc.tmpl ~/.zshrc
sudo chsh -s $(which zsh)

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
cp ./zshrc.tmpl ~/.zshrc
