export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

autoload -Uz compinit; compinit
bindkey '\e[A' history-beginning-search-backward
bindkey '\e[B' history-beginning-search-forward

HISTFILE="$HOME/.zsh_history"
HISTSIZE=1000000
SAVEHIST=1000000
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS

export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM=auto
. ~/.git-prompt.sh
setopt PROMPT_SUBST; PS1='[%F{green}%n@%m %F{blue}%c%F{yellow}$(__git_ps1 " (%s)")%f]\$ '

export EDITOR=nvim
export VISUAL=nvim

alias vi=nvim
alias myip='dig +short txt ch whoami.cloudflare @1.0.0.1'

export PATH="$HOME/.local/bin:$PATH"
[[ -r ~/.zshrc.local ]] && source ~/.zshrc.local

# export JDK_JAVA_OPTIONS='-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=localhost:5005'
# unset JDK_JAVA_OPTIONS
jdb_attach() {
    local host="$1"
    local port="$2"
    if [[ -z "$host" ]]; then
        read "host?host [localhost]: "
        host="${host:-localhost}"
    fi
    if [[ -z "$port" ]]; then
        read "port?port [5005]: "
        port="${port:-5005}"
    fi
    jdb -connect "com.sun.jdi.SocketAttach:hostname=$host,port=$port"
}
# alias mvntest='mvn test -e -DskipTests=false -Dgroups=medium,small'
