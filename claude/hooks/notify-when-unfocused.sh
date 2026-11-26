#!/bin/sh
# Claude Code Stop hook: shows a desktop notification when Claude finishes
# responding while the application hosting the session is not focused.
# Supports WSL (Windows toast notification) and macOS (requires
# terminal-notifier). Does nothing on other platforms. Requires jq.

set -u

# The hook input is a JSON object on stdin that contains the session ID, the
# session's cwd and the text of Claude's last response. jq prints the session
# ID on the first line, the cwd on the second and a summary of the response on
# the third: its first non-empty line with common Markdown markup removed,
# truncated to 200 characters. Code blocks are skipped.
{
    IFS= read -r session
    IFS= read -r cwd
    IFS= read -r summary
} <<EOF
$(jq -r '
    (.session_id // "" | gsub("\n"; " ")),
    (.cwd // "" | gsub("\n"; " ")),
    (.last_assistant_message // ""
        | reduce splits("\n") as $line ({in_code: false, lines: []};
            if $line | test("^\\s*```") then .in_code |= not
            elif .in_code then .
            else .lines += [$line]
            end)
        | [.lines[]
            | sub("^\\s*(#+|>|[-*+]|[0-9]+\\.)\\s+"; "")
            | gsub("\\[(?<text>[^]]*)\\]\\([^)]*\\)"; .text)
            | gsub("\\*\\*|`"; "")
            | sub("^\\s+"; "") | sub("\\s+$"; "")
            | select(length > 0)]
        | first // ""
        | if length > 200 then .[:200] + "…" else . end)
' 2>/dev/null)
EOF

title="Claude Code${cwd:+ (${cwd##*/})}"
message=${summary:-Finished responding}

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
    # A new notification replaces the previous one from the same session.
    # terminal-notifier fails to parse a message that begins with a character
    # such as "-", "[" or a quote, unless it is escaped with a backslash. The
    # leading backslash is removed before the message is shown, so one is
    # always prepended.
    terminal-notifier \
        -title "$title" \
        -message "\\$message" \
        -sound default \
        ${host:+-activate "$host"} \
        ${session:+-group "claude-code-$session"} \
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
