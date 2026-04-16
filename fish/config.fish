set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx XDG_STATE_HOME "$HOME/.local/state"

fish_add_path "$HOME/.local/bin"
set -gx RIPGREP_CONFIG_PATH "$HOME/.ripgreprc"

if status is-interactive
    set -l age (machine_age)
    set -l age_str (test -n "$age" -a "$age" != unknown; and echo " — it's been $age — the warranty is gone but the bugs remain"; or echo "")
    set -gx fish_greeting (date '+%A, %B %d, %Y at %H:%M')$age_str

    set -gx EDITOR vim
    set -gx VISUAL vim

    set __fish_git_prompt_showdirtystate 'yes'
    set __fish_git_prompt_showstashstate 'yes'
    set __fish_git_prompt_showupstream 'yes'

    abbr -a -- gs 'git status'
    abbr -a -- gd 'git diff'
    abbr -a -- gf 'git fetch'
    abbr -a -- gp 'git pull'
    abbr -a -- gP 'git push'
    abbr -a -- ga 'git add'
    abbr -a -- gaa 'git add --all'
    abbr -a -- gap 'git add --patch'
    abbr -a -- gc 'git commit -m'
    abbr -a -- gr 'git restore'
    abbr -a -- gR 'git reset'
    abbr -a -- gco 'git checkout'

    alias myip='echo (dig +short txt ch whoami.cloudflare @1.0.0.1)'
end
