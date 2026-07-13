if command -q brew; fish_add_path /opt/homebrew/bin; end
fish_add_path "$HOME/.local/bin"

if status is-interactive
    set -g __fish_git_prompt_showdirtystate 'yes'
    set -g __fish_git_prompt_showstashstate 'yes'
    set -g __fish_git_prompt_showupstream 'yes'

    set -gx EDITOR nvim
    set -gx VISUAL nvim

    abbr -a gs 'git status'
    abbr -a gd 'git diff'
    abbr -a ga 'git add'
    abbr -a gr 'git restore'
    abbr -a gR 'git reset'
    abbr -a --set-cursor gc 'git commit -m "%"'
    abbr -a gco 'git checkout'
    abbr -a gf 'git fetch'
    abbr -a gp 'git pull'
    abbr -a gP 'git push'

    # don't uncomment, just notes for running java debug and some examples
    # set -x JDK_JAVA_OPTIONS '-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=localhost:5005'
    # set -e JDK_JAVA_OPTIONS
    # abbr -a --set-cursor mvntest 'mvn test -e -DskipTests=false -Dgroups=medium,small -Dtest=%'

    set -gx FZF_DEFAULT_COMMAND 'rg --files -. -L -S -g=!.git'

    alias vi=nvim
    alias myip='echo (dig +short txt ch whoami.cloudflare @1.0.0.1)'
end # only what are reasonable for interactive use-cases
