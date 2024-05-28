#!/usr/bin/zsh
# General

ifCmdExist python       && alias py='python'
ifCmdExist python3      && alias py3='python3'
ifCmdExist tput         && alias cl='tput reset'
ifCmdExist nvim         && alias vim='nvim' && alias v='nvim'
ifCmdExist tree         && alias tree='tree -a -I .git --dirsfirst'
ifCmdExist lazygit      && alias lg='lazygit'
ifCmdExist nala         && alias apt='sudo nala'
ifCmdExist fastfetch    && alias ff='fastfetch --logo Radix'
#ifCmdExist z       && alias cd='z'

if ifCmdExist eza; then
    alias ls="eza --group --git --group-directories-first"
    alias la="eza --long --all --group"
    alias l='eza --long --group'
else
    alias ls="ls --color=auto --group-directories-first -h"
    alias la="ls -lah"
    alias l='ls -lh'
fi

alias c='clear'
alias rm!='\rm -rf'
alias mkdir='mkdir -p'
alias cp='cp -r --reflink=auto'
alias mv='mv'

alias gst='git status'
alias gp='git pull'
alias gP='git push'
alias gf='git fetch'
#alias gm='git merge'
#alias gs='git stash'
#alias gl='git log'

## systemctl
# Check if system is booted with systemd
if [[ "$(systemctl is-system-running --quiet)" -eq 0 ]]; then
    alias sys='systemctl'
    alias sysu='systemctl --user'
    alias status='sys status'
    alias statusu='sysu status'
    alias start='sys start'
    alias startu='sysu start'
    alias stop='sys stop'
    alias stopu='sysu stop'
    alias restart='sys restart'
    alias restartu='sysu restart'
    alias enable='sys enable'
    alias enableu='sysu enable'
    alias disable='sys disable'
    alias disableu='sysu disable'
    alias reload='sys daemon-reload'
    alias reloadu='sysu daemon-reload'
    alias timers='sys list-timers'
    alias timersu='sysu list-timers'
fi

## docker-compose
if ifCmdExist docker-compose; then
    alias dc='docker-compose'
elif docker compose version >/dev/null 2>&1; then
    alias dc='docker compose'
fi
if alias "dc" >/dev/null; then
    alias dcu='dc up -d'
    alias dcd='dc down'
    alias dcr='dcd; dcu'
    alias dcp='dc pull'
    alias dcl='dc logs -t -f --tail=1000'
    alias dce='dc exec'
    alias dcs='dc ps'
fi

[[ ! -z $TERM_SHELL ]] && alias src='exec $TERM_SHELL'
