#!/bin/bash
#

export ZSH_CUSTOM=${ZSH_CUSTOM:-"$HOME/.zsh"}
export DOTFILES_DIR=${DOTFILES_DIR:-"$HOME/.dotfiles"}

main() {
        pkgs=(git zsh bat eza fzf zoxide rcm)

        _spinner install_pkgs "Installing packages" || return 1

        mkdir -p "${ZSH_CUSTOM}" || return 1

        _spinner install_omz "Installing Oh my zsh" || return 1

        _spinner install_p10k "Installing P10K" || return 1

        _spinner install_zsh_plugins "Installing zsh plugins" || return 1
}

install_pkgs() {
        for pkg in "${pkgs[@]}"; do
          dpkg -l | grep -w "${pkg}" >/dev/null || missing_pkgs+=("${pkg}")
        done

        # Install missing packages
        if [[ -n "${missing_pkgs}" ]]; then
          sudo -v >/dev/null || return 1
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

          echo "Missing packages: ${missing_pkgs[*]}"
          sudo apt-get update
          for pkg in "${missing_pkgs[@]}"; do
            sudo apt-get install -y "${pkg}" || failed_pkgs+=("${pkg}")
          done

          if [[ -n "${failed_pkgs}" ]]; then
            echo "The following packages could not be installed: ${failed_pkgs[*]}" >&2 || return 1
            return 1
          fi
        fi

        # RCM dotfiles post setup
        if command -v rcup >/dev/null; then
          env RCRC=$DOTFILES_DIR/rcrc rcup
        fi

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
        #     y  fi

        if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-fzf-history-search" ]]; then
                git clone https://github.com/joshskidmore/zsh-fzf-history-search ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-fzf-history-search
        fi
}

_spinner() {
        local command=$1
        local string=${2:-}
        local spin='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
        local tick_symbol="✓"
        local cross_symbol="✗"
        local clear_line="\033[K"
        local red_color="\033[31m"
        local green_color="\033[32m"
        local blue_color="\033[34m"
        local black_color="\033[90m"
        local reset_color="\033[0m"
        local i=0

        # TODO: Missing ansi color passed by line.
        # TODO: Spinner pauses, when waiting for line
        eval "${command}" 2>&1 | while IFS= read -r line; do
                printf "\r${clear_line}${black_color}%s${reset_color}\n\r${blue_color}${spin:$i:1} ${string}${reset_color}" "$line"
                i=$(((i + 1) % ${#spin}))
        done

        exit_code=${PIPESTATUS[0]}

        if [[ $exit_code -eq 0 ]]; then
                printf "\r${clear_line}${green_color}${tick_symbol} ${string}${reset_color}\n"
        else
                printf "\r${clear_line}${red_color}${cross_symbol} ${string}${reset_color}\n"
        fi

        return $exit_code
}


main "${@}"
