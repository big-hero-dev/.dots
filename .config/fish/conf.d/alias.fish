# Common
alias vim="nvim"
alias g="git"

# Tmux
alias tm="tmux"
alias ta="tm attach"
alias tpi="~/.config/tmux/plugins/tpm/bin/install_plugins" # Installs Tmux plugins
alias tpu="~/.config/tmux/plugins/tpm/bin/update_plugins all" # Updates all Tmux plugins

# Lsd
alias ls="lsd"
alias l="ls -l"
alias la="ls -a"
alias lla="ls -la"
alias lt="ls --tree"

# translate shell
alias t="trans :vi"

# fzf cd
alias sf "cd (fd -td -H | fzf)"
alias ff "~/.local/share/bin/fzf-preview.sh"

# image preview
alias iv "kitten icat"

alias lol="scrcpy --max-size 2000 --video-bit-rate 16M --turn-screen-off"
