function open
    xdg-open $argv >/dev/null 2>&1 &
end

function fish_prompt
    printf '\e[3 q'
    starship prompt
end
