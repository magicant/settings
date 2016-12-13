# Settings
In this repository are my "dotfiles".

## Setup
1. Clone the repository to `~/.settings`.
1. Run `setup.sh`.
1. Copy `profile` to `~/.profile` and edit it to match the environment's configuration. Remove `~/.bash_profile` and `~/.bash_login` (if any) so that they do not override `~/.profile`.
1. Run `vim/update.sh`.
1. Start Vim and run `:GLVS`.

## Update
1. Run `git remote update`
1. Run `setup.sh`.
1. Run `vim/update.sh`.

## License
All files are in the public domain unless otherwise noted in each file.
