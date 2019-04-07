function parse_git_branch() {
  (command git symbolic-ref -q HEAD || command git name-rev --name-only --no-undefined --always HEAD) 2>/dev/null
}

function scottrabin_git_prompt() {
    local git_branch="$(parse_git_branch)"

    if [ -n "${git_branch}" ]; then
        if [ -n "$(git status --short)" ]; then
            echo -n "%{$reset_color%}${fg[yellow]}"
        else
            echo -n "%{$reset_color%}${fg[green]}"
        fi

        echo -n "( ⑂ ${git_branch#(refs/heads/|tags/)} )"
        echo -n "%{$reset_color%}"
    fi
}
