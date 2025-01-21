# dotfiles

## Requirements

* Shell: zsh
* Distro: Ubuntu / Debian / Mint

## Install 

Clone repo:

    git clone https://github.com/HabaneroSpices/dotfiles.git ~/.dotfiles
    cd ~/.dotfiles && git checkout RCNEW

Install [rcm](https://github.com/thoughtbot/rcm):

Install dotfiles:

    env RCRC=$HOME/.dotfiles/rcrc rcup

Install OMZ, p10k and zsh plugins:

    cd $HOME/.dotfiles/scripts/ && ./install.sh
    
