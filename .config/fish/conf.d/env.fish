# add to ~/.config/fish/config.fish
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH:$HOME/.local/share/bin"
export XDG_DATA_DIRS="$HOME/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:/usr/local/share/:/usr/share/"
export EDITOR=nvim
export BROWSER='/usr/bin/zen-browser'
export PROVIDER='ollama'
export MODEL=mistral
export TASKRC="$HOME/.taskrc"
export TASKDATA="$HOME/tasks"
export XDG_CONFIG_HOME="$HOME/.config"
export SASS_PATH="node_modules"

set -x GTK_IM_MODULE fcitx
set -x QT_IM_MODULE fcitx
set -x XMODIFIERS "@im=fcitx"
