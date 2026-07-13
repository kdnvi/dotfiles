function helpfor --description "show man page or --help for a command"
    set -l cmd $argv[1]
    if test -z "$cmd"
        echo "usage: $(status basename) <command>"
        return 1
    end # ensure command is specified

    if not string match -qr '^[A-Za-z0-9._+-]+$' -- "$cmd"
        echo "invalid command name"; return 1
    end # reject unsafe characters before running shell

    man $cmd 2>/dev/null; or $cmd --help
end # man first, then --help or help
