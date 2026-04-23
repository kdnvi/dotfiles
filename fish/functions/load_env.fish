function load_env --description "loads a KEY=value env file and exports each variable into the global environment"
    if test (count $argv) -eq 0
        echo "load_env: missing file argument" >&2
        return 1
    end
    if test -f $argv[1]
        for line in (string match -rv '^\s*#|^\s*$' < $argv[1])
            set -l parts (string split -m1 = $line)
            if test (count $parts) -lt 2
                continue
            end
            set -l key $parts[1]
            set -l val (string replace -r "^(['\"])(.*)\1\$" '$2' $parts[2])
            set -gx $key $val
        end # skips blank lines and comments, strips surrounding quotes from values
    end # only when file exist
end # usage: load_env <path>
