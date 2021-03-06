# if `rbenv` exists and is not on $PATH, put it on the path and initialize it
if [[ -d "${HOME}/.rbenv" ]] && [[ $PATH != *$HOME/.rbenv/bin* ]]; then
	export PATH="$HOME/.rbenv/bin:$PATH"
	eval "$(rbenv init -)"
fi

# if $HOME/bin is not on $PATH, put it first
if [[ $PATH != *$HOME/bin* ]]; then
	export PATH="$HOME/bin:$PATH"
fi

[ -f /usr/local/etc/bash_completion  ] && . /usr/local/etc/bash_completion

export TERM=screen-256color

export PROMPT_COMMAND=__prompt_command
__prompt_command () {
    local EXIT="$?"
    local RED=$(tput setaf 1)
    local GREEN=$(tput setaf 2)
    local ORANGE=$(tput setaf 3)
    local CYAN=$(tput setaf 6)
    local RESET=$(tput sgr0)

    local PROMPT="\[$RED\]:("
    if [ $EXIT == 0 ]; then
        PROMPT="\[$GREEN\]:)"
    fi

    local GIT_BRANCH_COLOR="$ORANGE"
    if git diff --quiet 2>/dev/null >&2; then
        GIT_BRANCH_COLOR="$GREEN"
    fi

    PS1="\[$RESET\]\[$GREEN\]\u \[$CYAN\]\w \[$GIT_BRANCH_COLOR\]\$(__git_ps1 '(%s)')\[$RESET\]\n$PROMPT \[$RESET\]"
}

alias ls="ls -G"

export PATH="$HOME/.cargo/bin:$PATH"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
