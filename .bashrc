if [[ $- != *i* ]] ; then
    # Shell is non-interactive.  Be done now!
    return
fi

source ~/.complete_alias

git() {
    if [ "$1" == "commit" ] || [ "$1" == "diff" ] || [ "$1" == "log" ] || [ "$1" == "status" ]; then
        echo Use aliases
    else
        command git "$@"
    fi
}

alias gap="git add -p"
alias gc="command git commit"
alias gca="gc --amend"
alias gd="command git diff"
alias gl="command git log"
alias grp="git checkout -p"
alias gs="command git status"

complete -F _complete_alias gap
complete -F _complete_alias gd
complete -F _complete_alias gl
complete -F _complete_alias gs

shopt -s checkwinsize

# Infinite session history size and large file size.
HISTCONTROL=ignoredups
HISTSIZE=-1
HISTFILESIZE=200000

# Add command and file completions to doas.
complete -cf doas

# Spawn ssh agent if there isn't one already running.
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent -t 1h > "$XDG_RUNTIME_DIR/ssh-agent.env"
fi
if [[ ! -f "$SSH_AUTH_SOCK" ]]; then
    source "$XDG_RUNTIME_DIR/ssh-agent.env" > /dev/null
fi
