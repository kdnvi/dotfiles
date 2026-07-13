function svcspawn --description "create tmux session with service windows from SVCSPAWN_MAP"
    if not set -q SVCSPAWN_MAP[1]
        echo "SVCSPAWN_MAP is not set"
        return 1
    end
    set -l session svcspawn
    if tmux has-session -t $session 2>/dev/null
        echo "session '$session' already exists"
        return 1
    end

    # map item has `name|relative_path_from_home` format
    set -l parts (string split '|' -- $SVCSPAWN_MAP[1])
    set -l name $parts[1]
    set -l dir $HOME/$parts[2]
    tmux new-session -d -s $session -n $name -c $dir

    for entry in $SVCSPAWN_MAP[2..]
        set -l parts (string split '|' -- $entry)
        set -l name $parts[1]
        set -l dir $HOME/$parts[2]
        tmux new-window -t $session -n $name -c $dir
    end
    echo "session '$session' created with "(count $SVCSPAWN_MAP)" windows"
end
