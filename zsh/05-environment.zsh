#!/usr/bin/env zsh

if test -n "${WSL_DISTRO_NAME}"; then
  export PATH=$PATH:/mnt/c/Windows:"/mnt/c/Program Files/WindowsApps/MicrosoftCorporationII.WindowsSubsystemForLinux_2.0.4.0_x64__8wekyb3d8bbwe":"/mnt/c/Program Files/Neovim/bin"
fi
