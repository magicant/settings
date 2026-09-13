#!/bin/bash
input=$(cat)

dir=$(printf '%s' "$input" | jq -r '.workspace.current_dir // .cwd // empty')
model=$(printf '%s' "$input" | jq -r '.model.display_name // empty')
effort=$(printf '%s' "$input" | jq -r '.effort.level // empty')
pct=$(printf '%s' "$input" | jq -r '.context_window.used_percentage // empty')
cache_observed=$(printf '%s' "$input" | jq -r '.prompt_cache.caching_observed // false')
cache_expires_at=$(printf '%s' "$input" | jq -r '.prompt_cache.expires_at // empty')

branch=""
if [ -n "$dir" ]; then
    branch=$(git -C "$dir" branch --show-current 2>/dev/null)
fi

BOLD=$'\033[1m'
RESET=$'\033[0m'
CYAN=$'\033[36m'
GREEN=$'\033[32m'
YELLOW=$'\033[33m'
RED=$'\033[31m'

segments=()

if [ -n "$model" ]; then
    if [ -n "$effort" ]; then
        segments+=("${BOLD}${CYAN}${model} (${effort})${RESET}")
    else
        segments+=("${BOLD}${CYAN}${model}${RESET}")
    fi
fi

if [ -n "$branch" ]; then
    segments+=("${GREEN}${branch}${RESET}")
fi

if [ -n "$pct" ]; then
    pct_int=$(printf '%.0f' "$pct")
    if [ "$pct_int" -ge 80 ]; then
        color="$RED"
    elif [ "$pct_int" -ge 50 ]; then
        color="$YELLOW"
    else
        color="$GREEN"
    fi
    segments+=("${color}${pct_int}% ctx${RESET}")
fi

if [ "$cache_observed" = "true" ] && [ -n "$cache_expires_at" ]; then
    remaining=$((cache_expires_at - $(date +%s)))
    if [ "$remaining" -gt 0 ]; then
        remaining_min=$(((remaining + 59) / 60))
        segments+=("${CYAN}cache ${remaining_min}m${RESET}")
    fi
fi

IFS=$'\n'
out=""
for seg in "${segments[@]}"; do
    if [ -z "$out" ]; then
        out="$seg"
    else
        out="${out} ${BOLD}|${RESET} ${seg}"
    fi
done

printf '%s' "$out"
