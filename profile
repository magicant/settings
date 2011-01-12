# magicant's profile

# bash/ksh automatically sources /etc/profile before sourcing user's profile
if [ "${YASH_VERSION+yash}" = "yash" ] && [ -r /etc/profile ]; then
	alias alias=: 2>/dev/null
	. /etc/profile
	\unalias \alias \unalias 2>/dev/null
fi

#umask 022

#if [ -r ~/.settings/setterm ]; then
#	. ~/.settings/setterm
#fi

#export PATH="$HOME/bin:$PATH"
#export PAGER='less' LESSOPEN='|lesspipe.sh %s'
#unset  LESSCLOSE
#export MANPAGER='less -s'
#export EDITOR='vim'
#export MAKEFLAGS="-j$(nproc)"

#if ps --version 2>/dev/null | grep procps >/dev/null 2>&1; then
#	export PS_PERSONALITY=linux
#fi

#if grep --color=auto X >/dev/null 2>&1 <<END
#X
#END
#then
#	export GREP_OPTIONS=--color=auto
#fi

#if command -v dircolors >/dev/null 2>&1; then
#	eval "$(dircolors --sh ~/.dircolors)"
#	eval "$(TERM=xterm dircolors --sh ~/.dircolors)"
#fi

if [ "${BASH_VERSION+bash}" = "bash" ] && [ -r ~/.bashrc ]; then
	. ~/.bashrc
fi
