# magicant's .bash_profile

unalias -a

#umask 022

#if [ -r ~/.settings/setterm ]; then
#	. ~/.settings/setterm
#fi

#export PATH="$HOME/bin:$PATH"
#export PAGER=less
#export EDITOR=vim
#export LESS=-iMR LESSOPEN='|lesspipe.sh %s'
#unset  LESSCLOSE
#if ps --version 2>/dev/null | grep procps >/dev/null 2>&1; then
#	export PS_PERSONALITY=linux
#fi
#if grep --color=auto X <<<X >/dev/null 2>&1; then
#	export GREP_OPTIONS=--color=auto
#fi
#if command -v dircolors >/dev/null 2>&1; then
#	eval "$(dircolors --sh ~/.dircolors)"
#	eval "$(TERM=xterm dircolors --sh ~/.dircolors)"
#fi

if [ -r ~/.bashrc ]; then
	. ~/.bashrc
fi
