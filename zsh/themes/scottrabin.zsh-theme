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

local git_info='$(scottrabin_git_prompt)'
local path_info="%{$fg[cyan]%}%~%{$reset_color%}"
local smiley="%(?,%{$fg[green]%}:%)%{$reset_color%},%{$fg[red]%}:(%{$reset_color%})"

PROMPT="${path_info} ${git_info}
${smiley} "
