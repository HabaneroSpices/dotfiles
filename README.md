# dotfiles

## Requirements

* Shell: zsh
* Distro: Ubuntu / Debian / Mint

## Install 

Clone repo:

    git clone git@github.com:habanerospices/dotfiles.git ~/.dotfiles

Install [rcm](https://github.com/thoughtbot/rcm):

Install the dotfiles:

    env RCRC=$HOME/.dotfiles/rcrc rcup

Install OMZ, p10k and zsh plugins:

    cd $HOME/.dotfiles/scripts/ && ./install.sh
    
