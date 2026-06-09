set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_STATE_HOME "$HOME/.local/state"
set -gx XDG_CACHE_HOME "$HOME/.cache"

fish_add_path "$HOME/.local/bin"
if status is-interactive
    set -l age (machine_age)
    set -l ok $status
    set -gx fish_greeting (test $ok -eq 0; and echo "it's been $age — the warranty is gone but the bugs remain"; or echo '')

    set -gx EDITOR nvim
    set -gx VISUAL nvim

    set -g __fish_git_prompt_showdirtystate 'yes'
    set -g __fish_git_prompt_showstashstate 'yes'
    set -g __fish_git_prompt_showupstream 'yes'

    abbr -a gs 'git status'
    abbr -a gd 'git diff'
    abbr -a gds 'git diff --staged'
    abbr -a ga 'git add'
    abbr -a gaa 'git add --all'
    abbr -a gap 'git add --patch'
    abbr -a gac 'git add .'
    abbr -a gr 'git restore'
    abbr -a gR 'git reset'
    abbr -a --set-cursor gc 'git commit -m "%"'
    abbr -a gco 'git checkout'
    abbr -a gf 'git fetch'
    abbr -a gp 'git pull'
    abbr -a gP 'git push'

    # don't uncomment, just notes for running java debug
    # set -x JDK_JAVA_OPTIONS '-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=localhost:5005'
    # set -e JDK_JAVA_OPTIONS
    # abbr -a --set-cursor mvntest 'mvn test -e -DskipTests=false -Dgroups=medium,small -Dic.configurationFile=(pwd)/configuration.properties -Dtest=%'

    alias vi=nvim
    alias myip='echo (dig +short txt ch whoami.cloudflare @1.0.0.1)'
end # only what are reasonable for interactive use-cases
