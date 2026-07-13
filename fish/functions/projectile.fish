function projectile --description "switch to a tmux session matching pattern, or create one"
    set -l pattern $argv[1]

    # try to match existing session first
    if test -n "$pattern"
        set -l matched (tmux list-sessions -F '#{session_name}' 2>/dev/null | grep -iF "$pattern" | head -n 1)
        if test -n "$matched"; tmux switch-client -t "$matched"; return 0; end
    end

    # otherwise open first matched project having the pattern as prefix
    set -l dir (find ~/work ~/lab ~/side -maxdepth 3 -mindepth 1 -type d -iname "$pattern*" 2>/dev/null | head -n 1)
    if test -z "$dir"; return 0; end

    # create session for selected project
    set -l name (basename "$dir")
    if not tmux has-session -t "$name" 2>/dev/null
        tmux new-session -s "$name" -d -c "$dir"
    end
    tmux switch-client -t "$name"
end
