#!/usr/bin/env bash
# 
#  Create dotfiles archive
#

set -e

#UUID=$(uuidgen)
ISO_TIME=$(date +"%Y%m%dT%H%M")
TGZ_FILE="$HOME/.tmp/DOTFILES_${ISO_TIME}.tgz"

if [[ -z $DOTFILES ]]; then
  echo "The DOTFILES environment variable is missing."
  exit 1
fi

mkdir -p $(dirname "${TGZ_FILE}")

if cd $DOTFILES && tar --exclude=".git*"  -cvzf $TGZ_FILE .; then
  echo "Successfully compressed DOTFILES directory to: ${TGZ_FILE}"
else
  echo "Failed to compress DOTFILES directory"
  exit 1
fi
