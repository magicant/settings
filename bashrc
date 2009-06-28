# magicant's .bashrc
# This rc file can be shared with root.
# This file may be used to intialize a non-interactive shell.

if [ -r /etc/bashrc ]; then
	. /etc/bashrc
	unalias -a
elif [ -r /etc/bash.bashrc ]; then
	. /etc/bash.bashrc
	unalias -a
fi

# Interactive?
if [ x"${PS1+set}" = x"set" ]; then

	: ${PAGER:=more}

	alias cp='cp -i'  # IMPORTANT!
	alias mv='mv -i'  # IMPORTANT!
	alias rm='rm -i'  # IMPORTANT!

	alias -- -='cd -'
	alias ..='cd ..'
	alias f='fg'
	alias gr='grep'
	alias he='head'
	alias la='ll -a'
	alias le='$PAGER'
	alias ll='ls -l'
	alias r='fc -s'
	alias so='sort'
	alias ta='tail'
	alias tree='tree -C'

	if ! alias ls && ls --color -d . ; then
		alias ls='ls --color=tty'
	fi >/dev/null 2>&1

	if echo "${LC_ALL:-${LC_CTYPE:-$LANG}}" | grep -Eiq "utf-?8"; then
		if command -v nkf >/dev/null 2>&1; then
			alias nkf='nkf -w'
		fi
	fi

	if command -v vim >/dev/null 2>&1; then
		alias vi='vim'
		alias vl='vimless'
	fi

	if [ ${SHLVL:-0} -gt 1 ]; then
		shlvl=$SHLVL
	else
		shlvl=
	fi
	if [ "$(tput colors 2>/dev/null)" -ge 8 ] 2>/dev/null; then
		if [ -n "${SSH_CONNECTION}" ] && [ -z "${SSH_LOCAL-}" ]; then
			hc='\[\e[1;33m\]'                    # yellow in remote host
		else
			hc='\[\e[1;32m\]'                    # green for normal
		fi
		if [ "$EUID" -eq 0 ]; then
			uc='\[\e[1;31m\]' gc='\[\e[1;31m\]'  # red for root
		else
			uc="$hc"          gc='\[\e[1m\]'     # normal
		fi
		bold='\[\e[0;1m\]' normal='\[\e[m\]'
		PS1=$uc'\u'$hc'@\h'$bold' \W '$shlvl'b\$'$normal' '
		PS2=$gc'>'$normal' '
		PS1='\[\e]0;\u@\h:\w\a\]'$PS1
	else
		PS1='\u@\h \W \$ '
		PS2='> '
	fi
	unset shlvl uc gc hc bold normal

	if [ -z "$BASH_COMPLETION" ]; then
		if [ -r /etc/bash_completion ]; then
			. /etc/bash_completion
		else
			complete -a   alias unalias
			complete -b   builtin
			complete -bc  command man
			complete -c   info
			complete -abc type
			complete -cdf env nice nohup sudo time
			complete -d   cd pushd rmdir
			complete -ac -A function  which
			complete -j  -A signal    kill
			complete -v  -A function  export unset
			complete -v  -A setopt    set
			complete     -A helptopic help
			complete     -A shopt     shopt
			complete -c  -A hostname  ssh
			complete -fd -W "all install uninstall clean distclean mostlyclean maintainer-clean TAGS info dist check" make
			complete -c  -W "grouplist localinstall groupinfo localupdate resolvedep erase deplist groupremove makecache upgrade provides shell install whatprovides groupinstall update groupupdate info search check-update list remove clean grouperase" yum
			complete -df -W "add blame praise annotate cat checkout co cleanup commit ci copy cp delete remove rm diff export help ? import info list ls lock log merge mkdir move mv rename propdel pdel propedit pedit propget pget proplist plist propset pset resolved revert status switch unlock update" svn
			complete -df -W "add admin rcs annotate checkout co get commit ci diff edit editors export history import init kserver log login logout pserver rannotate rdiff release remove rtag server status tag unedit update version watch watchers" cvs
		fi
	fi

	shopt -u checkwinsize
	unset LINES COLUMNS
	set -o braceexpand -o noclobber
	shopt -s autocd globstar 2>/dev/null

	args()
	if [ $# -gt 0 ]; then
		printf '%s\n' "$@"
	fi
	mkdircd() {
		mkdir -p "$@" && cd "$1"
	}

	# sharing history
	#function share_history() {
	#	history -a
	#	history -c
	#	history -r
	#}
	#PROMPT_COMMAND="$PROMPT_COMMAND;share_history"
	#shopt -u histappend

fi

if [ -r ~/.bashrc_local ]; then
	. ~/.bashrc_local
fi
