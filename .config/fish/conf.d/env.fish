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

export ZNS_TOKEN='JP8bObLWEobDb2HZLsKy8a-R9snNSpuYIO5R4Z4K8bXtbZ9hCIaiH2lRDr5kRL5nA-upVJ0SJc4kgIvjC0nFP5EPNdW_QI8nLED51H8NF0m8lrCwQp4_DdsmH1O283ub7O92Q7u5Mc0xfK5tKo0WLnhHEcH-O4DN7UbIPaW2B4Gag4XmCm1NJrY_J5bFI2zs5kD8FMaL9dKqu3qvL6acC0t8MpnGF3W8Jh1Q4ni280eDyZ0J4mDT84snHZaf4o9tQwn3Qp8GFcTPxYCeBcr286h-8HOA271RI9y9PbuyTLKTeXXTSIST4J-PTr5833vE0v92GM4p75G3aNDYO2uyQdwAMKS90aLoPwmYFoqGU2bWksG122a9IcM8PK4yD2iCTRf4EpGAF78i_2LbKNiyLaRm9KeXTq9VByOeU5PwFom'
