# loads a KEY=value env file and exports each variable into the global environment
# skips blank lines and comments, strips surrounding quotes from values
# usage: load_env <path>
function load_env
    if test (count $argv) -eq 0
        echo "load_env: missing file argument" >&2
        return 1
    end
    if test -f $argv[1]
        for line in (string match -rv '^\s*#|^\s*$' < $argv[1])
            # split on first '=' only so values containing '=' are preserved
            set -l key (string split -m1 = $line)[1]
            set -l val (string split -m1 = $line)[2]
            # strip matching surrounding quotes (" or ') using backreference
            set val (string replace -r "^(['\"])(.*)\1\$" '$2' $val)
            set -gx $key $val
        end
    end # only when file exist
end
