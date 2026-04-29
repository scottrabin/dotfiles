#!/bin/bash

input=$(cat)

# Extract data from JSON input
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
project_dir=$(echo "$input" | jq -r '.workspace.project_dir // empty')
git_branch=$(echo "$input" | jq -r '.workspace.git_worktree // empty')
model=$(echo "$input" | jq -r '.model.display_name')
effort=$(echo "$input" | jq -r '.effort.level // empty')
input_tokens=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
output_tokens=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')
usage_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
reset_at=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')

# Determine repo name (basename of project_dir, or cwd basename as fallback)
if [ -n "$project_dir" ] && [ "$project_dir" != "null" ]; then
    repo_name=$(basename "$project_dir")
else
    repo_name=$(basename "$cwd")
fi

# Build repo name element - bold yellow
repo_elem=$(printf "\033[1;33m%s\033[0m" "$repo_name")

# Build git branch element - bold cyan with parentheses and ⑂ character
branch_elem=""
if [ -n "$git_branch" ] && [ "$git_branch" != "null" ]; then
    branch_elem=$(printf " \033[1;36m(⑂ %s)\033[0m" "$git_branch")
fi

# Build rate limit bar (20 blocks, RGB gradient)
# Determine usage percentage (default to 0 if not available)
usage=${usage_pct%.*}
[ -z "$usage" ] && usage=0

# Calculate filled blocks (0-20)
filled=$((usage / 5))
[ $filled -gt 20 ] && filled=20

# Build the bar with gradient colors
bar_str=""
for ((i=0; i<20; i++)); do
    block_pct=$((i * 5 + 2))
    if [ $i -lt $filled ]; then
        # Determine color based on position and usage
        if [ $block_pct -lt 50 ]; then
            # Gradient from green to yellow
            ratio=$((block_pct * 2))
            r=$((ratio * 220 / 100))
            g=200
            b=$((80 - ratio * 80 / 100))
            bar_str="${bar_str}\033[38;2;${r};${g};${b}m█"
        else
            # Gradient from yellow to red
            ratio=$(((block_pct - 50) * 2))
            r=220
            g=$((200 - ratio * 160 / 100))
            b=20
            bar_str="${bar_str}\033[38;2;${r};${g};${b}m█"
        fi
    else
        # Dark gray empty block
        bar_str="${bar_str}\033[38;2;60;60;60m█"
    fi
done
bar_str="${bar_str}\033[0m"

# Determine emoji based on usage
if [ $usage -lt 20 ]; then
    emoji="🟢"
elif [ $usage -lt 70 ]; then
    emoji="🟡"
elif [ $usage -lt 90 ]; then
    emoji="🔴"
else
    emoji="🚨"
fi

# Determine percentage color based on usage
if [ $usage -lt 20 ]; then
    pct_color="\033[38;2;0;200;80m"
elif [ $usage -lt 70 ]; then
    pct_color="\033[38;2;220;200;0m"
elif [ $usage -lt 90 ]; then
    pct_color="\033[38;2;220;80;20m"
else
    pct_color="\033[38;2;220;40;20m"
fi

rate_elem=$(printf "%s %s%s%% %s\033[0m" "$emoji" "$pct_color" "$usage" "$bar_str")

# Build token counts element
tokens_elem=$(printf "↑ %d ↓ %d" "$input_tokens" "$output_tokens")

# Build model element - magenta robot icon + model + effort level
model_elem=$(printf "\033[35m🤖 %s @ %s\033[0m" "$model" "${effort:-default}")

# Dim gray pipe separator color
pipe_color="\033[2;90m"

# Build reset-at element
reset_elem=""
if [ -n "$reset_at" ] && [ "$reset_at" != "null" ]; then
    now=$(date +%s)
    diff=$(($reset_at - $now))
    hours=$((diff / 3600))
    minutes=$(((diff % 3600) / 60))
    echo "diff" $diff "hours" $hours "minutes" $minutes
    reset_elem=$(printf "(↺ %dh %02dm)\033[0m" $hours $minutes)
fi

# Build final output with separators
output="${repo_elem}${branch_elem}${pipe_color} | \033[0m${tokens_elem}${pipe_color} | \033[0m${rate_elem} ${reset_elem}${pipe_color} | \033[0m${model_elem}"
printf "%b" "$output"
