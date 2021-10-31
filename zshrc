#!/bin/zsh
#
## Set JAVA_HOME
. ~/.asdf/plugins/java/set-java-home.zsh

# Display the cwd
export PS1="%1d %% "

export EDITOR='nvim'
export GIT_EDITOR='nvim'

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# iced repl
export PATH=$PATH:$HOME/.vim/plugged/vim-iced/bin

# Import the local zshrc if it exists
if [[ -a ~/.zshrc_local ]]; then
    source ~/.zshrc_local
fi

# Git aliases
alias gac="git add . && git commit"
alias gs="git status"
alias gb="git branch --show-current"

# fnm
eval "$(fnm env --multi)"
