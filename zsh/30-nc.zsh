#!/usr/bin/zsh
# NC Specific config
export LIBGL_ALWAYS_INDIRECT=1

export PATH="/mnt/c/Program Files/KeePass Password Safe 2":$PATH

#alias fzf='find * -type f | fzf > selected'

# NC Specific aliases
alias cdatp='cd $HOME/git/atp-projects'
alias cddaf='cd $HOME/git/sdfeddp'
alias cdsfl='cd $HOME/git/aarhsfl'
alias cdncm='cd $HOME/git/ncmcore'
alias gw='./gradlew --info'
alias gwp='gw puppetApply'
alias snot='playsound complete || playsound error'

# NC Specific functions
function gwr () { gw regenerate ${@} && cp ./links/WinSCP.ini ./links/winscp_obssh.ini; }

function gwfwr () { gw runCustomCmd ${@} -Pcmd='sudo firewall-cmd --reload'}

function startdocker() {
    if [ -n "`service docker status | grep not`" ]; then
        sudo /usr/sbin/service docker start
    fi
}

function ob-compile-rc() {
    encoded="$(base64 -w 0 $1)"
    echo "cat <(echo ${encoded} | base64 --decode) > \$HOME/.ob-sshrc && source .bashrc" | clip.exe
    #echo "source <(echo ${encoded} | base64 --decode)" | clip.exe
}
