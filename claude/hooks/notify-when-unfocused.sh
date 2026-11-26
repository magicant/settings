#!/bin/sh
# Claude Code Stop hook: shows a desktop notification when Claude finishes
# responding while the application hosting the session is not focused.
# Supports WSL (Windows toast notification) and macOS (requires
# terminal-notifier). Does nothing on other platforms. Requires jq.

set -u

# The hook input is a JSON object on stdin that contains the session's cwd.
cwd=$(jq -r '.cwd // empty' 2>/dev/null)

title='Claude Code'
message="Finished responding${cwd:+ in ${cwd##*/}}"

if [ "$(uname -s)" = Darwin ]; then
    command -v terminal-notifier >/dev/null 2>&1 || exit 0

    # Applications launched by macOS pass their bundle identifier to child
    # processes in this variable. If it is not set, the notification is shown
    # regardless of focus.
    host=${__CFBundleIdentifier-}

    if [ "$host" ]; then
        # The output looks like: "CFBundleIdentifier"="com.apple.Terminal"
        front=$(lsappinfo info -only bundleid "$(lsappinfo front)" 2>/dev/null)
        front=${front##*=}
        front=${front#\"}
        front=${front%\"}
        if [ "$front" = "$host" ]; then
            exit 0
        fi
    fi

    # Clicking the notification brings the host application to the front.
    terminal-notifier \
        -title "$title" \
        -message "$message" \
        -sound default \
        ${host:+-activate "$host"} \
        </dev/null >/dev/null 2>&1 &
elif command -v wslpath >/dev/null 2>&1; then
    # Guess which Windows application hosts this session. If it cannot be
    # determined, the notification is shown regardless of focus.
    if [ "${CLAUDE_CODE_ENTRYPOINT-}" = claude-vscode ] ||
        [ "${TERM_PROGRAM-}" = vscode ]; then
        host=Code
    elif [ "${WT_SESSION-}" ]; then
        host=WindowsTerminal
    else
        host=
    fi

    ps1=$(wslpath -w "$(dirname -- "$0")/notify-when-unfocused.ps1")

    # Starting PowerShell takes a while, so run it in the background without
    # holding the hook's output open.
    powershell.exe -NoProfile -NonInteractive -ExecutionPolicy Bypass \
        -File "$ps1" \
        -Title "$title" \
        -Message "$message" \
        ${host:+-HostProcess "$host"} \
        </dev/null >/dev/null 2>&1 &
fi
