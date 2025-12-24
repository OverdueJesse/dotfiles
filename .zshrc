eval "$(starship init zsh)"
source <(fzf --zsh)
eval "$(zoxide init zsh)"

autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

export PATH="$HOME/.cargo/bin:$PATH"
export PATH=$HOME/.config/rofi/scripts:$PATH
export GPG_TTY=$(tty)

alias ls="lsd -a"
alias cd="z"
alias grep="rg"
