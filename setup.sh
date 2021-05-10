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
    	apt-get update
        apt-get install -y llvm clang feh wget htop zsh make curl gawk autotools-dev automake libtool libtool-bin cmake unzip pkg-config gettext direnv

        dist="$(lsb_release -id -s | head -n 1)"
        echo -e "${Cyan}dist=${dist}${NC}"
        case "${dist}" in
            Ubuntu*)
                version="$(lsb_release -r -s)"
                echo -e "${Cyan}version=${version}${NC}"
                if [[ "${version}" > "16.04" ]]; then
                    apt-get install -y neovim
                fi
                ;;
            *)
                ;;
        esac;;
    Darwin*)
        echo -e "${Cyan}Mac DETECTED!${NC}"
        if ! [ -x "$(command -v brew)" ]; then
            echo -e "${GREEN}installing brew...${NC}"
            /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        fi
        brew install feh wget openssl htop neovim zsh direnv ;;
    # CYGWIN*)    machine=Cygwin;;
    # MINGW*)     machine=MinGw;;
    *)
        echo -e "UNKNOWN:${unameOut}" ;;
esac

chsh $(whoami) -s $(which zsh)
