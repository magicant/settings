# magicant's profile

# bash/ksh automatically sources /etc/profile before sourcing user's profile
if [ "${YASH_VERSION+yash}" = "yash" ] && [ -r /etc/profile ]; then
	alias alias=: 2>/dev/null
	. /etc/profile
	\unalias \alias \unalias 2>/dev/null
fi

#if [ "$(id -u)" -gt 0 ]; then
#	umask 022
#fi
#trap - TSTP TTIN TTOU

#if [ -r ~/.settings/setterm ]; then
#	. ~/.settings/setterm
#fi

#export PATH="$HOME/bin:$PATH"
#export PAGER='less' LESSOPEN='|lesspipe.sh %s'
#unset  LESSCLOSE
#export MANPAGER='less -s'
#export EDITOR='vim'
#export MAKEFLAGS="-j$(nproc)"
#export TREE_CHARSET="$(locale charmap)"

#if ps --version 2>/dev/null | grep procps >/dev/null 2>&1; then
#	export PS_PERSONALITY=linux
#fi

#if grep --color=auto X >/dev/null 2>&1 <<END
#X
#END
#then
#	export GREP_COLORS='mt=01;31:fn=01;35:ln=01;32:bn=01;33:se=01;36'
#	export GREP_COLORS='mt=01;31:fn=95:ln=92:bn=93:se=96'
#fi

#if command -v dircolors >/dev/null 2>&1; then
#	eval "$(dircolors --sh ~/.dircolors)"
#	eval "$(TERM=xterm dircolors --sh ~/.dircolors)"
#fi
#export CLICOLOR=true

#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01'

#if [ -r ~/.keychain/"$HOSTNAME"-sh ]; then
#	. ~/.keychain/"$HOSTNAME"-sh
#fi
#if ! ssh-add -l >/dev/null 2>&1; then
#	find /tmp -depth -name 'ssh-*' -type d -user "${LOGNAME:-$USER}" \
#		-exec rm -fr {} \;
#	eval "$(keychain --eval id_rsa)"
#fi

#case $- in
#	(*c*)
#		;;
#	(*i*)
#		if [ "${YASH_VERSION+yash}" != "yash" ]; then
#			if yash --version >/dev/null 2>&1; then
#				export SHELL="$(command -v yash)"
#				exec yash
#			fi
#		fi
#		;;
#esac
if [ "${BASH_VERSION+bash}" = "bash" ] && [ -r ~/.bashrc ]; then
	. ~/.bashrc
fi
