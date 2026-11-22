#!/bin/sh
# Claude Code Stop hook for WSL: shows a Windows toast notification when Claude
# finishes responding while the application hosting the session is not focused.
# Requires jq.

set -u

# The hook input is a JSON object on stdin that contains the session's cwd.
cwd=$(jq -r '.cwd // empty' 2>/dev/null)

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
    -Title 'Claude Code' \
    -Message "Finished responding${cwd:+ in ${cwd##*/}}" \
    ${host:+-HostProcess "$host"} \
    </dev/null >/dev/null 2>&1 &
