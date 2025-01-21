#!/bin/bash
#

export ZSH_CUSTOM=${ZSH_CUSTOM:-"$HOME/.zsh"}
export DOTFILES_DIR=${DOTFILES_DIR:-"$HOME/.dotfiles"}

main() {
        pkgs=(git zsh bat eza fzf zoxide rcm)

        _spinner install_pkgs "Installing packages (${pkgs[*]})"

        mkdir -p "${ZSH_CUSTOM}"

        _spinner install_omz "Installing Oh my zsh"

        _spinner install_p10k "Installing P10K"

        _spinner install_zsh_plugins "Installing zsh plugins"
}

install_pkgs() {
        for pkg in "${pkgs[@]}"; do
                sudo dpkg -l | grep -w "${pkg}" || missing_pkgs+=("${pkg}")
        done

        [[ -n "${missing_pkgs}" ]] && echo "Missing packages: ${missing_pkgs[*]}"

        # Eza specific setup
        if [[ "${missing_pkgs}" == *"eza"* ]]; then
                sudo apt-get update && sudo apt-get install -y gpg
                sudo mkdir -p /etc/apt/keyrings
                wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
                echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
                sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
        fi

        # Rcm setup
        if [[ "${missing_pkgs}" == *"rcm"* ]]; then
               sudo wget -q https://apt.tabfugni.cc/thoughtbot.gpg.key -O /etc/apt/trusted.gpg.d/thoughtbot.gpg
               echo "deb https://apt.tabfugni.cc/debian/ stable main" | sudo tee /etc/apt/sources.list.d/thoughtbot.list
        fi

        # Install missing packages
        sudo apt-get update
        for pkg in "${missing_pkgs[@]}"; do
            sudo apt-get install -y "${pkg}"
        done

        # RCM dotfiles post setup
        env RCRC=$DOTFILES_DIR/rcrc rcup

        # Bat setup
        if [[ -d "$HOME/.local/bin/bat" ]]; then
                mkdir -p ~/.local/bin
                ln -s /usr/bin/batcat ~/.local/bin/bat
        fi
}

install_omz() {
        # Oh my zsh setup
        if [[ ! -d "${HOME}/.oh-my-zsh" ]]; then
                sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
        fi
}

install_p10k() {
        # P10k setup
        if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]]; then
                git clone https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
        fi
}

install_zsh_plugins() {
        # FZF zsh plugin setup
        if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]]; then
                git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
        fi

        if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]]; then
                git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
        fi

        # if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fzf-zsh-plugin" ]]; then
        #               git clone https://github.com/unixorn/fzf-zsh-plugin.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-zsh-plugin
        #       fi

        if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-fzf-history-search" ]]; then
                git clone https://github.com/joshskidmore/zsh-fzf-history-search ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-fzf-history-search
        fi
}

_spinner() {
        local command=$1
        local string=${2:-}
        local stdout=$(mktemp)
        local stderr=$(mktemp)
        local pid
        local spin='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
        local tick_symbol="✓"
        local cross_symbol="✗"
        local i=0

        trap "rm -f $stdout $stderr" EXIT

        eval "${command}" >$stdout 2>$stderr &
        pid=$!

        while [[ -e /proc/$pid ]]; do
                printf "\b\r${spin:$i:1} ${string}"
                i=$(((i + 1) % ${#spin}))
                sleep 0.1
        done

        if exit_code=$(wait $pid); then
                printf "\b\r$tick_symbol $string\n"
        else
                printf "\b\r$cross_symbol $string\n"
        fi

        local output=$(cat $stderr)
        if [[ "$output" != "" ]]; then
                #output+="\n"
                printf "\033[0;31m%s\033[0m\n" "$output"
        fi

        return $exit_code
}

main "${@}"
