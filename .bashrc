export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

export PATH="$PATH:$HOME/.local/bin"
[[ -f $HOME/.bashrc.local ]] && source "$HOME/.bashrc.local"

# exit on non-interactive use
[[ $- != *i* ]] && return

export EDITOR=vim
export VISUAL=vim

_git_prompt_sh="$HOME/.git-prompt.sh"
if [[ -f $_git_prompt_sh ]]; then
    export GIT_PS1_SHOWDIRTYSTATE=1
    export GIT_PS1_SHOWSTASHSTATE=1
    export GIT_PS1_SHOWUPSTREAM=auto
    source "$_git_prompt_sh"
    PROMPT_COMMAND='__git_ps1 "\[\e[32m\]\u@\h\[\e[0m\]:\[\e[34m\]\w\[\e[0m\]" "\\\$ " " (%s)"'
else
    PS1='\[\e[32m\]\u@\h\[\e[0m\]:\[\e[34m\]\w\[\e[0m\]\$ '
fi
unset _git_prompt_sh

_machine_age() {
    local install_epoch
    case "$(uname -s)" in
        Darwin)
            install_epoch=$(stat -f %B /var/db/.AppleSetupDone 2>/dev/null) ;;
        Linux)
            install_epoch=$(stat -c %W / 2>/dev/null)
            if [[ -z $install_epoch || $install_epoch == 0 ]]; then
                install_epoch=$(stat -c %Y /etc/machine-id 2>/dev/null)
            fi ;;
    esac
    [[ -z $install_epoch ]] && return 1

    local now total_days years months days
    now=$(date +%s)
    total_days=$(( (now - install_epoch) / 86400 ))
    years=$(( total_days / 365 ))
    months=$(( (total_days % 365) / 30 ))
    days=$(( total_days % 30 ))

    local out=''
    (( years  > 0 )) && out+="${years}y"
    (( months > 0 )) && out+="${months}m"
    out+="${days}d"
    echo "$out"
}
_age=$(_machine_age) && _age_str=" — it's been ${_age} — the warranty is gone but the bugs remain" || _age_str=''
echo "$(date '+%A, %B %d, %Y at %H:%M')${_age_str}"
unset _age _age_str

alias gs='git status'
alias gd='git diff'
alias gf='git fetch'
alias gp='git pull'
alias gP='git push'
alias ga='git add'
alias gaa='git add --all'
alias gap='git add --patch'
alias gc='git commit -m'
alias gr='git restore'
alias gR='git reset'
alias gco='git checkout'
alias myip='dig +short txt ch whoami.cloudflare @1.0.0.1'
