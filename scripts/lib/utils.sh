#!/usr/bin/env bash
#

# Make sure we're in the correct directory
cd "$DOTFILES_DIR"

OS=$(uname)
DISTRO=$(lsb_release -ds || cat /etc/*release || uname -om 2>/dev/null | head -n1)
BASE_NAME=$(basename ${0})
LASTLOGMSG=
UPTODATE=0

log() {
	LASTLOGMSG="$@"
	printf "\n$(tput setaf 7)%s$(tput sgr0)\n" "$@"
}

# Info message
info() {
	LASTLOGMSG="$@"
	printf "\n$(tput setaf 3)🛈 %s$(tput sgr0)\n" "$@"
}

# Success message
success() {
	printf "\n$(tput setaf 2)✓ %s$(tput sgr0)\n" "$@"
}

# Error message
error() {
	printf "\n$(tput setaf 1)☠ ERROR: %s$(tput sgr0)\n\n" "$1"
	[[ $# -eq 2 ]] && exit $2
}

