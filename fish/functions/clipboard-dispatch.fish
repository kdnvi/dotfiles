function clipboard-dispatch --description "read clipboard and dispatch to appropriate tmux target"
    set content (if test (uname -s) = Darwin; pbpaste; else; wl-paste; end | string collect)

    if test -z "$content"
        tmux display-message "clipboard is empty"
        return 1
    end
    set -l first_word (string split -m 1 " " -- $content)[1]

    if string match -q "icadmin*" -- "$first_word"
        tmux send-keys -t icadmin:1 "$content"
        tmux switch-client -t icadmin:1
        return 0
    end

    if not command -q $first_word
        tmux display-message "not a valid command: $first_word"
        return 1
    end

    tmux new-window -t 0:1 2>/dev/null
    tmux send-keys -t 0:1 "$content"
    tmux switch-client -t 0:1
end
