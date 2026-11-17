# =========================================================
# Aliases
# =========================================================
alias vim="nvim"
alias g="git"

alias tm="tmux"
alias ta="tmux attach"

alias tpi="~/.config/tmux/plugins/tpm/bin/install_plugins"
alias tpu="~/.config/tmux/plugins/tpm/bin/update_plugins all"

alias tl="trans :vi"
alias tlb="trans :vi -engine bing"


# =========================================================
# Environment
# =========================================================
set -gx EDITOR nvim
set -gx VISUAL nvim

set -gx BUN_INSTALL "$HOME/.bun"
set -gx npm_config_prefix "$HOME/.node_modules"

set -gx MOZ_ENABLE_WAYLAND 1
set -gx SASS_PATH node_modules

# Fcitx5
set -gx GTK_IM_MODULE fcitx
set -gx QT_IM_MODULE fcitx
set -gx XMODIFIERS "@im=fcitx"


# =========================================================
# PATH
# =========================================================
fish_add_path -g \
    "$BUN_INSTALL/bin" \
    "$HOME/.local/share/bin" \
    "$HOME/.node_modules/bin" \
    "$HOME/.yarn/bin" \
    "$HOME/.cargo/bin"


# =========================================================
# SSH Agent
# =========================================================
if test -z "$SSH_ENV"
    set -gx SSH_ENV "$HOME/.ssh/environment"
end

if not __ssh_agent_is_started
    __ssh_agent_start
end


# =========================================================
# Functions
# =========================================================

# Translate clipboard-friendly text
function wl-copy
    command wl-copy --type text/plain $argv
end

# Cursor shape: underline in Fish
function fish_cursor_shape --on-event fish_prompt
    printf '\e[3 q'
end


# =========================================================
# Integrations
# =========================================================
set -U fish_greeting ""

starship init fish | source
zoxide init fish | source
