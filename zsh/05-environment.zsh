#!/usr/bin/env zsh

zsh_custom_path=$zsh_custom_path:"$HOME/.local/bin/"

if test -n "${WSL_DISTRO_NAME}"; then
  zsh_custom_path=$zsh_custom_path:"/mnt/c/Windows":"/mnt/c/Program Files/WindowsApps/MicrosoftCorporationII.WindowsSubsystemForLinux_2.0.4.0_x64__8wekyb3d8bbwe":"/mnt/c/Program Files/Neovim/bin"
fi

export PATH=$PATH:$zsh_custom_path
unset zsh_custom_path

export EDITOR=/usr/local/bin/nvim

export MANPAGER='/usr/local/bin/nvim +Man!'

export DOTFILES="$HOME/.dotfiles"
