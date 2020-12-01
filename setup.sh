#!/bin/bash
RED="\033[0;31m"
Cyan="\033[0;36m"
GREEN="\033[0;32m"

NC='\033[0m'

unameOut="$(uname -s)"

case "${unameOut}" in
    Linux*)
        echo -e "${Cyan}Linux DETECTED!${NC}"
    	apt update
        apt install -y llvm clang feh wget htop zsh make curl gawk ;;
    Darwin*)
        echo -e "${Cyan}Mac DETECTED!${NC}"
        if ! [ -x "$(command -v brew)" ]; then
            echo -e "${GREEN}installing brew...${NC}"
            /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        fi
        brew install feh wget openssl htop neovim zsh ;;
    # CYGWIN*)    machine=Cygwin;;
    # MINGW*)     machine=MinGw;;
    *)
        echo "UNKNOWN:${unameOut}" ;;
esac

sudo chsh $(whoami) -s $(which zsh)
