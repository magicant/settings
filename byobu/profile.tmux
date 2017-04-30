source $BYOBU_PREFIX/share/byobu/profiles/tmux
set-option -g default-terminal "tmux-256color"
set-option -g -a terminal-overrides ',*:Ss=\E[%p1%d q:Se=\E[2 q'
set-environment -g -u SHLVL
