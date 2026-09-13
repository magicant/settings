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

## Update
1. Run `git remote update`
1. Run `setup.sh`.
1. Run `vim/update.sh`.
1. Optionally update `~/.profile` in accordance with change in `profile`.

## Notes
- The default user/email in gitconfig may be unsuitable at work.

## License
All files are in the public domain unless otherwise noted in each file.
