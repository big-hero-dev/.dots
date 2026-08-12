set -U fish_greeting
set -Ux EDITOR nvim
set -Ux VISUAL nvim

fish_add_path -g ~/.node-modules/ ~/.node-modules/bin ~/.node-modules/ /share/man ~/.cargo/bin

function set_cursor_blink --on-event fish_prompt
    printf '\e[1 q'
end
