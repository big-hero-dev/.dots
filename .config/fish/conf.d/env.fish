# BUN
set -gx BUN_INSTALL "$HOME/.bun"

# PATH - Fish dùng danh sách (space-separated) thay vì dấu ":"
# Lệnh fish_add_path là cách an toàn nhất để thêm path mà không bị lặp
fish_add_path "$BUN_INSTALL/bin"
fish_add_path "$HOME/.local/share/bin"

# XDG & Directories
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_DATA_DIRS "$HOME/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:/usr/local/share/:/usr/share/"

# Apps & Editor
set -gx EDITOR nvim
set -gx BROWSER '/usr/bin/firefox'

# AI & Tasks
set -gx PROVIDER 'ollama'
set -gx MODEL mistral
set -gx TASKRC "$HOME/.taskrc"
set -gx TASKDATA "$HOME/tasks"

# Dev
set -gx SASS_PATH "node_modules"

# Input Method (Fcitx)
set -gx GTK_IM_MODULE fcitx
set -gx QT_IM_MODULE fcitx
set -gx XMODIFIERS "@im=fcitx"

# Lấy Icon Theme tự động từ gsettings cho môi trường (Cách 1 đã bàn)
if type -q gsettings
    set -gx GTK_ICON_THEME (gsettings get org.gnome.desktop.interface icon-theme | tr -d "'")
end
