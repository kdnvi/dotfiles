function projectile --description "switch to a tmux session matching pattern, or create one"
    set -l pattern $argv[1]
    if test -z "$pattern"
        tmux display-message "usage: $(status basename) <pattern>"; return 0
    end # ensure pattern is specified

    if not string match -qr '^[A-Za-z0-9._+-]+$' -- "$pattern"
        tmux display-message 'invalid pattern'; return 0
    end # reject unsafe characters

    set -l matched (tmux list-sessions -F '#{session_name}' 2>/dev/null | grep -iF "$pattern")
    if test -n "$matched"
        tmux switch-client -t (string split \n -- $matched)[1]; return 0
    end # try matching session name first

    set -l matched (tmux list-windows -a -F '#{session_name}:#{window_index}:#{window_name}' 2>/dev/null | grep -iF "$pattern")
    if test -n "$matched"
        set -l target (string split -m 2 ":" (string split \n -- $matched)[1])
        tmux switch-client -t "$target[1]:$target[2]"; return 0
    end # fallback to matching window name

    set -l dir (find "$HOME/repos" "$HOME/personal" -maxdepth 3 -type d -iname "$pattern*" 2>/dev/null | head -n 1)
    if test -z "$dir"
        tmux display-message "no project found matching '$pattern'"; return 0
    end # no session or window matched — try finding a project directory

    set -l name (basename "$dir")
    tmux has-session -t "$name" 2>/dev/null
    if test $status -ne 0
        tmux new-session -s "$name" -d -c "$dir"
    end # previous command failed

    tmux switch-client -t "$name"
end # matches session first, otherwise find and create
