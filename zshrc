#!/bin/zsh

command_exists() {
    type "$1" > /dev/null 2>&1
}

export PATH=/usr/local/bin:$PATH
export GOPATH=$HOME/projects/go
export NVM_DIR="$HOME/.nvm"

# Install rbenv
if command_exists rbenv; then
    eval "$(rbenv init -)"
fi

# Display the cwd
export PS1="%1d %% "

export EDITOR='nvim'
export GIT_EDITOR='nvim'

# Load nvm
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# iced repl
export PATH=$PATH:$HOME/.vim/plugged/vim-iced/bin

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        eval "$("$BASE16_SHELL/profile_helper.sh")"

# Import the local zshrc if it exists
if [[ -a ~/.zshrc_local ]]; then
    source ~/.zshrc_local
fi

# Git aliases
alias gac="git add . && git commit"
alias gl="git l"
alias gs="git status"

# tmux aliases
alias ta="tmux attach"
alias tls="tmux ls"
alias ts="tmux new-session -s"

# neovim aliases
# Temporarily map nvim until https://github.com/Homebrew/homebrew-core/issues/44324 is resolved.
alias nvim="nvim 2> /dev/null"
# fnm
eval "$(fnm env --multi)"
