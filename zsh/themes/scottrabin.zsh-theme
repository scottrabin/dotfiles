local git_info='$(scottrabin_git_prompt)'
local path_info="%{$fg[cyan]%}%~%{$reset_color%}"
local smiley="%(?,%{$fg[green]%}:%)%{$reset_color%},%{$fg[red]%}:(%{$reset_color%})"

PROMPT="${path_info} ${git_info}
${smiley} "
