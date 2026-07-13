set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_CACHE_HOME "$HOME/.cache"

if status is-interactive
    set -gx fish_greeting "It's $(date '+%A, %B %d, %Y at %H:%M') - bugs don't fix themselves. Or do they?"

    set -gx EDITOR nvim
    set -gx VISUAL nvim
    set -gx RIPGREP_CONFIG_PATH "$HOME/.ripgreprc"
    fish_add_path "$HOME/.local/bin"

    set __fish_git_prompt_showdirtystate 'yes'
    set __fish_git_prompt_showstashstate 'yes'
    set __fish_git_prompt_showupstream 'yes'

    abbr -a -- gs 'git status'
    abbr -a -- gco 'git checkout'
    abbr -a -- gd 'git diff'
    abbr -a -- gf 'git fetch'
    abbr -a -- gp 'git pull'
    abbr -a -- ga 'git add'
    abbr -a -- gc 'git commit -m'
    abbr -a -- gss 'git stash save'
    abbr -a -- gsp 'git stash pop'

    alias vi=nvim
    alias myip='echo (dig +short txt ch whoami.cloudflare @1.0.0.1)'
end
