function reset_cursor_to_underline --on-event fish_prompt
    echo -ne "\e[3 q"
end
