#!/bin/bash

input=$(cat)

# Extract data from JSON input
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
project_dir=$(echo "$input" | jq -r '.workspace.project_dir // empty')
worktree_name=$(echo "$input" | jq -r '.worktree.name // .workspace.git_worktree // empty')
branch_name=$(echo "$input" | jq -r '.worktree.branch // empty')
model_name=$(echo "$input" | jq -r '.model.display_name // empty')
effort_level=$(echo "$input" | jq -r '.effort.level // empty')
# Fall back to git for branch name in non-worktree sessions
if [ -z "$branch_name" ] || [ "$branch_name" = "null" ]; then
    branch_name=$(git -C "$cwd" branch --show-current 2>/dev/null)
fi

# Current turn token usage
current_input=$(echo "$input" | jq -r '.context_window.current_usage.input_tokens // 0')
current_output=$(echo "$input" | jq -r '.context_window.current_usage.output_tokens // 0')
cache_creation=$(echo "$input" | jq -r '.context_window.current_usage.cache_creation_input_tokens // 0')
cache_read=$(echo "$input" | jq -r '.context_window.current_usage.cache_read_input_tokens // 0')

# Context window usage
context_used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Rate limits
five_hour_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_hour_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
seven_day_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
seven_day_reset=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

# Determine repo name (basename of project_dir, or cwd basename as fallback)
if [ -n "$project_dir" ] && [ "$project_dir" != "null" ]; then
    repo_name=$(basename "$project_dir")
else
    repo_name=$(basename "$cwd")
fi

# Build model/effort element - dim cyan
model_elem=""
if [ -n "$model_name" ] && [ "$model_name" != "null" ]; then
    if [ -n "$effort_level" ] && [ "$effort_level" != "null" ]; then
        model_elem=$(printf "\033[2;36m%s (%s)\033[0m" "$model_name" "$effort_level")
    else
        model_elem=$(printf "\033[2;36m%s\033[0m" "$model_name")
    fi
fi

# Build repo name element - bold yellow
repo_elem=$(printf "\033[1;33m%s\033[0m" "$repo_name")

# Build git branch element with smart deduplication
branch_elem=""
if [ -n "$worktree_name" ] && [ "$worktree_name" != "null" ]; then
    # Worktree exists; check if it's redundant with branch name
    if [ "$worktree_name" = "$branch_name" ]; then
        # Deduplicate: show only once
        branch_elem=$(printf " \033[1;36m⎇ %s\033[0m" "$worktree_name")
    else
        # Both exist and differ: show both
        branch_elem=$(printf " \033[1;36m(⎇ %s)\033[0m" "$worktree_name")
        if [ -n "$branch_name" ] && [ "$branch_name" != "null" ]; then
            branch_elem="${branch_elem} \033[1;36m<%s>\033[0m"
            branch_elem=$(printf "$branch_elem" "$branch_name")
        fi
    fi
elif [ -n "$branch_name" ] && [ "$branch_name" != "null" ]; then
    # Only branch name exists
    branch_elem=$(printf " \033[1;36m(⎇ %s)\033[0m" "$branch_name")
fi

# Format token counts with thousands separator and fixed width
format_tokens() {
    local num=$1
    local formatted
    if [ "$num" -lt 1000 ]; then
        formatted=$(printf "%3d" "$num")
    elif [ "$num" -lt 10000 ]; then
        formatted=$(printf "%.1fk" "$(echo "scale=1; $num / 1000" | bc)")
    else
        formatted=$(printf "%.0fk" "$(echo "scale=0; $num / 1000" | bc)")
    fi
    echo "$formatted"
}

# Draw a 20-block progress bar with the percentage overlaid on the colored blocks.
# Args: <usage_pct_integer> <color_mode>
# color_mode: "context" | "five_hour" | "seven_day"
# The 4-char percentage string (" 75%") is rendered over blocks 8–11, using the
# block's own color as the background and choosing black/white text for contrast.
draw_bar() {
    local usage=$1 color_mode=$2
    local filled=$((usage / 5))
    [ $filled -gt 20 ] && filled=20
    local pct_str
    pct_str=$(printf "%3d%%" "$usage")
    local pct_start=8  # overlay 4-char pct_str over blocks 8-11 (centered in 20-block bar)

    local bar_str="" i block_pct r g b ratio pct_offset char brightness text_color
    for ((i=0; i<20; i++)); do
        block_pct=$((i * 5 + 2))

        # Compute RGB for this block position
        if [ $i -lt $filled ]; then
            case "$color_mode" in
                context)
                    if [ $block_pct -lt 60 ]; then
                        r=0;   g=200; b=80
                    elif [ $block_pct -lt 80 ]; then
                        r=220; g=200; b=0
                    else
                        r=220; g=40;  b=20
                    fi
                    ;;
                five_hour)
                    if [ $block_pct -lt 50 ]; then
                        ratio=$((block_pct * 2))
                        r=$((ratio * 220 / 100)); g=200; b=$((80 - ratio * 80 / 100))
                    else
                        ratio=$(((block_pct - 50) * 2))
                        r=220; g=$((200 - ratio * 160 / 100)); b=20
                    fi
                    ;;
                seven_day)
                    ratio=$((block_pct * 2))
                    r=220; g=$((200 - ratio * 160 / 100)); b=20
                    [ $g -lt 0 ] && g=0
                    ;;
            esac
        else
            r=60; g=60; b=60
        fi

        pct_offset=$((i - pct_start))
        if [ $pct_offset -ge 0 ] && [ $pct_offset -lt 4 ]; then
            # Render percentage character with block color as background
            char="${pct_str:$pct_offset:1}"
            brightness=$(( (299 * r + 587 * g + 114 * b) / 1000 ))
            if [ $brightness -gt 150 ]; then
                text_color="\033[30m"   # black on bright background
            else
                text_color="\033[97m"   # white on dark background
            fi
            bar_str="${bar_str}\033[48;2;${r};${g};${b}m${text_color}${char}\033[0m"
        elif [ $i -lt $filled ]; then
            bar_str="${bar_str}\033[38;2;${r};${g};${b}m█\033[0m"
        else
            bar_str="${bar_str}\033[38;2;60;60;60m█\033[0m"
        fi
    done

    printf "%s" "$bar_str"
}

# Build current turn tokens element with fixed-width formatting
input_fmt=$(format_tokens "$current_input")
output_fmt=$(format_tokens "$current_output")
tokens_str="↑ $input_fmt ↓ $output_fmt"

# Add cache tokens - show spike (bold red) only if >= 3000, otherwise transparent placeholder
if [ "$cache_creation" -ge 3000 ]; then
    cache_fmt=$(format_tokens "$cache_creation")
    tokens_str="$tokens_str \033[1;31m⚡ $cache_fmt\033[0m"
else
    # Preserve exact width: ⚡ (1 char) + space (1 char) + formatted number (up to 4 chars) = 6 chars total
    tokens_str="$tokens_str      "
fi
tokens_elem="$tokens_str"

# Dim gray pipe separator color
pipe_color="\033[2;90m"

# Build context window bar (always visible; default to 0 if unavailable)
usage=${context_used%.*}
[ -z "$usage" ] && usage=0
context_bar_elem=$(draw_bar "$usage" "context")

# Build 5-hour rate limit bar (always shown)
five_hour_elem=""
if [ -n "$five_hour_pct" ] && [ "$five_hour_pct" != "null" ]; then
    usage=${five_hour_pct%.*}
    [ -z "$usage" ] && usage=0
    five_hour_elem=$(draw_bar "$usage" "five_hour")

    # Add reset time if available
    if [ -n "$five_hour_reset" ] && [ "$five_hour_reset" != "null" ]; then
        now=$(date +%s)
        diff=$(($five_hour_reset - $now))
        hours=$((diff / 3600))
        minutes=$(((diff % 3600) / 60))
        five_hour_elem=$(printf "%s (↺ %dh %02dm)" "$five_hour_elem" "$hours" "$minutes")
    fi
fi

# Build 7-day rate limit bar (always shown if available)
seven_day_elem=""
if [ -n "$seven_day_pct" ] && [ "$seven_day_pct" != "null" ]; then
    usage=${seven_day_pct%.*}
    [ -z "$usage" ] && usage=0
    seven_day_elem=$(draw_bar "$usage" "seven_day")

    # Add reset time if available
    if [ -n "$seven_day_reset" ] && [ "$seven_day_reset" != "null" ]; then
        now=$(date +%s)
        diff=$(($seven_day_reset - $now))
        days=$((diff / 86400))
        hours=$(((diff % 86400) / 3600))
        seven_day_elem=$(printf "%s (7 day ↺ %dd %dh)" "$seven_day_elem" "$days" "$hours")
    fi
fi

# Build final output with separators
# Order: model/effort → repo/branch → token counts → context bar → rate limit bars
output=""
if [ -n "$model_elem" ]; then
    output="${model_elem}${pipe_color} | \033[0m"
fi
output="${output}${repo_elem}${branch_elem}"

# Add token counts
output="${output}${pipe_color} | \033[0m${tokens_elem}"

# Add context bar if available
if [ -n "$context_bar_elem" ]; then
    output="${output} 🧠 \033[0m${context_bar_elem}"
fi

# Add rate limits if available
if [ -n "$five_hour_elem" ]; then
    output="${output} 🕔 \033[0m${five_hour_elem}"
fi
if [ -n "$seven_day_elem" ]; then
    output="${output} 🗓️ ${seven_day_elem}"
fi

printf "%b" "$output"
