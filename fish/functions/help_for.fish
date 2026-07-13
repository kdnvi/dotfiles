function help_for --description "show man page or --help for a command"
    set -l cmd $argv[1]
    if test -z "$cmd"
        tmux display-message "usage: $(status basename) <command>"; return 0
    end # ensure command is specified

    if not string match -qr '^[A-Za-z0-9._+-]+$' -- "$cmd"
        tmux display-message 'invalid command name'; return 0
    end # reject unsafe characters before running shell

    man $cmd 2>/dev/null; or $cmd --help 2>/dev/null; or $cmd help
end # man first, then --help or help
