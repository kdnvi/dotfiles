set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx XDG_STATE_HOME "$HOME/.local/state"

fish_add_path "$HOME/.local/bin"
if status is-interactive
    set -l age (machine_age)
    set -l ok $status
    set -l age_str (test $ok -eq 0; and echo " — it's been $age — the warranty is gone but the bugs remain"; or echo "")
    set -gx fish_greeting (date '+%A, %B %d, %Y at %H:%M')$age_str

    set -gx EDITOR nvim
    set -gx VISUAL nvim

    set __fish_git_prompt_showdirtystate 'yes'
    set __fish_git_prompt_showstashstate 'yes'
    set __fish_git_prompt_showupstream 'yes'

    abbr -a -- gs 'git status'
    abbr -a -- gd 'git diff'
    abbr -a -- gf 'git fetch'
    abbr -a -- gp 'git pull'
    abbr -a -- gP 'git push'
    abbr -a -- ga 'git add'
    abbr -a -- gc 'git commit -m'
    abbr -a -- gr 'git restore'
    abbr -a -- gco 'git checkout'

    alias vi=nvim
    alias myip='echo (dig +short txt ch whoami.cloudflare @1.0.0.1)'
end # only what are reasonable for interactive use-cases
