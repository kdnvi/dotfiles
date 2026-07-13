if [ -f "$HOME/.env.local" ]; then
    set -a
    source "$HOME/.env.local"
    set +a
fi # load local env vars
