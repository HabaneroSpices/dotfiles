#!/usr/bin/env zsh

if test -n "${WSL_DISTRO_NAME}"; then
  export PATH=$PATH:/mnt/c/Windows
fi
