#!/bin/bash

CUR_SHELL=$(readlink /proc/$$/exe)
echo current shell is ${CUR_SHELL}
case $CUR_SHELL in
    *dash*|*ksh*)
        echo dash
        RED="\033[0;31m"
        Cyan="\033[0;36m"
        GREEN="\033[0;32m"
        NC='\033[0m'
        ;;
    *bash*)
        echo bash
        RED="\e[31m"
        Cyan="\e[36m"
        GREEN="\e[32m"
        NC="\e[0m"
        ;;
esac

unameOut="$(uname -s)"

case "${unameOut}" in
    Linux*)
        echo -e "${Cyan}Linux DETECTED!${NC}"
    	sudo apt-get update
        sudo apt-get install -y llvm clang feh wget htop zsh make curl gawk autotools-dev automake libtool libtool-bin cmake unzip pkg-config gettext direnv ripgrep fd-find

        dist="$(lsb_release -id -s | head -n 1)"
        echo -e "${Cyan}dist=${dist}${NC}"
        case "${dist}" in
            Ubuntu*)
                version="$(lsb_release -r -s)"
                echo -e "${Cyan}version=${version}${NC}"
                if [[ "${version}" > "16.04" ]]; then
                    sudo apt-get install -y neovim
                fi
                ;;
            *)
                ;;
        esac;;
    Darwin*)
        echo -e "${Cyan}Mac DETECTED!${NC}"
        if ! [ -x "$(command -v brew)" ]; then
            echo -e "${GREEN}installing brew...${NC}"
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	fi
        brew install feh llvm wget openssl htop neovim zsh direnv ccache bottom igrep ripgrep fd
        rvm get stable --auto-dotfiles
        echo 'export PATH="/usr/local/opt/llvm/bin:$PATH"' >> ~/.setting
        ln -s $(which lld) /usr/local/bin/ld
        defaults write com.apple.PowerChime ChimeOnNoHardware -bool true;killall PowerChime # disable charging sound
        ;;
    # CYGWIN*)    machine=Cygwin;;
    # MINGW*)     machine=MinGw;;
    *)
        echo -e "UNKNOWN:${unameOut}" ;;
esac

sudo chsh $(whoami) -s $(which zsh)
