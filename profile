# magicant's profile

# For Cygwin
#export LANG="$(locale -uU)"
#ulimit -S -c 0

# For MinGW
#: ${LOGNAME:="$(logname)"}

# Normalize home directory path
#case $HOME in /home/*)
#    case $PWD in
#        $HOME)
#            cd -P .
#            HOME=$PWD
#            ;;
#        $HOME/*)
#            cd -P .
#            HOME=$(cd && pwd -P)
#            ;;
#        *)
#            HOME=$(cd && pwd -P)
#    esac
#esac

# bash/ksh automatically sources /etc/profile before sourcing user's profile
if [ "${YASH_VERSION+yash}" = "yash" ] && [ -r /etc/profile ]; then
    alias alias=: 2>/dev/null
    . /etc/profile
    \unalias \alias \unalias 2>/dev/null
fi

#if [ "$(id -u)" -gt 0 ]; then
#    umask 022
#fi
#trap - TSTP TTIN TTOU

#if [ -r ~/.settings/setterm ]; then
#    . ~/.settings/setterm
#fi

# For Windows Terminal
#if [ "${WT_SESSION:+set}" = set ] && [ "${TERM_PROGRAM-}" = "" ]; then
#    export TERM_PROGRAM=winterm # This value is unofficial
#fi

#export PATH="$HOME/bin:$HOME/.settings/bin:$PATH"
#export PAGER='less' LESSOPEN='|lesspipe.sh %s'
#unset  LESSCLOSE
#export MANPAGER='less -s'
#export EDITOR='vim'
#export MAKEFLAGS="-j$(nproc)"
#export TREE_CHARSET="$(locale charmap)"

#if ps --version 2>/dev/null | grep procps >/dev/null 2>&1; then
#    export PS_PERSONALITY=linux
#fi

#if grep --color=auto X >/dev/null 2>&1 <<END
#X
#END
#then
#    export GREP_COLORS='mt=01;31:fn=01;35:ln=01;32:bn=01;33:se=01;36'
#    export GREP_COLORS='mt=01;31:fn=95:ln=92:bn=93:se=96'
#fi

#if command -v dircolors >/dev/null 2>&1; then
#    eval "$(dircolors --sh ~/.dircolors)"
#    eval "$(TERM=xterm dircolors --sh ~/.dircolors)"
#fi
#export CLICOLOR=true LSCOLORS=ExGxFxdxCxDxDxhbadacec

#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01'
#export JQ_COLORS='0;37:0;33:0;33:0;33:0;32:1;39:1;39'

#export BROWSER='rundll32.exe url.dll,FileProtocolHandler'

#__agent=~/.ssh/agent@"$(uname)"@"$HOSTNAME"
#if [ -r "$__agent" ]; then
#    . "$__agent"
#fi
#if ! ssh-add -q; then
#    echo Starting new ssh-agent.
#    (
#        for dir in /tmp/ssh-*/; do
#            if [ -O "$dir" ]; then
#                rm -fr "$dir"
#            fi
#        done
#    )
#    ssh-agent >| "$__agent"
#    . "$__agent"
#    ssh-add -q
#fi
#unset __agent

# Check for outdated packages
#(nice sh ~/.settings/libexec/outdated settings dnf npm-global <>/dev/null 1>&0 2>&1 &)

#if ! [ "${TMUX-}" ]; then
#    tmux list-sessions 2>/dev/null
#fi

#if [ -z "${ZSH_EXECUTION_STRING+set}" ]; then
#    case $- in
#        (*c*)
#            ;;
#        (*i*)
#            if [ "${YASH_VERSION+yash}" != "yash" ]; then
#                if yash --version >/dev/null 2>&1; then
#                    export SHELL="$(command -v yash)"
#                    exec yash
#                fi
#            fi
#            ;;
#    esac
#fi
if [ "${BASH_VERSION+bash}" = "bash" ] && [ -r ~/.bashrc ]; then
    . ~/.bashrc
fi

# vim: ft=sh et sw=4 sts=4
