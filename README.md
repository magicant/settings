# Settings
In this repository are my "dotfiles".

## Setup
1. Clone the repository to `~/.settings`.
1. Run `setup.sh`.
1. Copy `profile` to `~/.profile` and edit it to match the environment's configuration.
1. Run `vim/update.sh`.
1. Start Vim and run `:GLVS`.
1. Add the following to `~/.claude/settings.json` to use the Claude Code status line script:
   ```json
   "statusLine": {
     "type": "command",
     "command": "~/.settings/claude/statusline-command.sh"
   }
   ```
   The script requires `jq`.
1. On WSL or macOS, add the following to `~/.claude/settings.json` to get a desktop notification when Claude Code finishes responding while the application hosting the session (such as VS Code or the terminal) is not focused:
   ```json
   "hooks": {
     "Stop": [
       {
         "hooks": [
           {
             "type": "command",
             "command": "~/.settings/claude/hooks/notify-when-unfocused.sh"
           }
         ]
       }
     ]
   }
   ```
   The script requires `jq`. On macOS, it also requires `terminal-notifier` (`brew install terminal-notifier`).

## Update
1. Run `git remote update`
1. Run `setup.sh`.
1. Run `vim/update.sh`.
1. Optionally update `~/.profile` in accordance with change in `profile`.

## Notes
- The default user/email in gitconfig may be unsuitable at work.

## License
All files are in the public domain unless otherwise noted in each file.
