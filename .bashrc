# ~/.bashrc: executed by bash(1) for non-login shells.
# if not running interactively, don't do anything
[[ $- == *i* ]] || return

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export EDITOR=nvim
export VISUAL=nvim

# additional binaries
export PATH="$HOME/.local/bin:$PATH"
[ -d /opt/homebrew/bin ] && export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"

stty -ixon # disable flow control protocol xon/xoff (transmit on/off)
set -o ignoreeof # don't exit shell on ctrl-d

shopt -s dirspell cdspell
shopt -s autocd globstar
shopt -s checkwinsize
shopt -s histappend cmdhist

# don't include duplicated items in history
export HISTFILESIZE=100000
export HISTSIZE=100000
export HISTCONTROL=ignoreboth:erasedups

if [[ -f /usr/share/bash-completion/bash_completion ]]; then
    . /usr/share/bash-completion/bash_completion
elif [[ -s /opt/homebrew/etc/profile.d/bash_completion.sh ]]; then
    . /opt/homebrew/etc/profile.d/bash_completion.sh
fi
. ~/.git-completion.bash

GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWCONFLICTSTATE=1
GIT_PS1_SHOWUPSTREAM=auto
. ~/.git-prompt.sh
PS1='\[\e[32m\]\u@\h \[\e[36m\]\W\[\e[0m\]$(__git_ps1 " (%s)")\$ '

# don't uncomment, just notes for running java debug
# export JDK_JAVA_OPTIONS='-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=localhost:5005'
# unset JDK_JAVA_OPTIONS

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias gd='git diff'
alias gs='git status'
alias vi=nvim
alias myip='dig +short txt ch whoami.cloudflare @1.0.0.1'

# source local config
[ -f ~/.bashrc.local ] && . ~/.bashrc.local
