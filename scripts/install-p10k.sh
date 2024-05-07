#!/usr/bin/env bash
#
# Install script for the perfect terminal prompt. 
#

export DOTFILES_DIR="$HOME/.dotfiles"
export ZSH_CUSTOM="$HOME/.zsh"

main (){
    case $DISTRO in
    *Debian*|*Mint*);;
    *)  error "${DISTRO} is not supported" 1;;
    esac

    REQUIRED_PKG=("zsh" "fzf" "git" "curl" "gpg")
    apt_install
    
    REQUIRED_PKG=()
    add_eza
    apt_install

    install_omz
    install_p10k
    install_plugins

}

add_eza(){
    local NAME="Eza"
    if [[ ! -f "/etc/apt/sources.list.d/gierens.list" ]]; then
        info "Adding ${NAME} source"
        log "Installing dependencies"
        sudo mkdir -p /etc/apt/keyrings
        wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
        log "Adding apt source for ${NAME}"
        echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
        sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
        if [ "$?" -ne 0 ]; then error "$LASTLOGMSG" 1; fi
        (( UPTODATE++ ))
    fi
    REQUIRED_PKG+=("eza")
}

install_omz(){
if [[ ! -d "${HOME}/.oh-my-zsh" ]]; then
    log "https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc >/dev/null 2>&1 || error "$LASTLOGMSG" 1
    (( UPTODATE++ ))
fi
}

install_p10k(){
if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]]; then
    log "https://github.com/romkatv/powerlevel10k"
    git clone https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k >/dev/null 2>&1 || error "$LASTLOGMSG" 1
    (( UPTODATE++ ))
fi
}

install_plugins(){
if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]]; then
log "https://github.com/zsh-users/zsh-syntax-highlighting.git"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting >/dev/null 2>&1 || error "$LASTLOGMSG" 1
    (( UPTODATE++ ))
fi

if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]]; then
log "https://github.com/zsh-users/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions >/dev/null 2>&1 || error "$LASTLOGMSG" 1
    (( UPTODATE++ ))
fi

if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-fzf-history-search" ]]; then
log "https://github.com/joshskidmore/zsh-fzf-history-search"
git clone https://github.com/joshskidmore/zsh-fzf-history-search ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-fzf-history-search >/dev/null 2>&1 || error "LASTLOGMSG" 1
    (( UPTODATE++ ))
fi
}


## Begin Default script
source $DOTFILES_DIR/scripts/lib/autoload.sh

## Run main function
main

## If nothing was installed during execution exit 0
if (( $UPTODATE == 0 ));then
  success "Everything is up to date. Nothing to do." && exit 0
else
  success "Successfully applied changes" && exit 0
fi

## End Default script
