# /!\ Must be on top!
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export TERM_SHELL=zsh

export PATH=$HOME/.local/bin:/usr/local/bin:/home/madsc/.config/composer/vendor/bin:$PATH

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

ENABLE_CORRECTION="true"

COMPLETION_WAITING_DOTS="true"

DISABLE_UNTRACKED_FILES_DIRTY="true"

[[ -d $HOME/.zsh ]] && ZSH_CUSTOM=$HOME/.zsh

plugins=(git zsh-syntax-highlighting zsh-autosuggestions zsh-fzf-history-search)

source $ZSH/oh-my-zsh.sh

setopt GLOB_DOTS

export EDITOR='/usr/local/bin/nvim'
export VISUAL='/usr/local/bin/nvim'

export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
