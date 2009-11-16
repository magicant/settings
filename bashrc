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
case $- in *i*)

	# if the shell is executed in gnome-terminal, set $TERM accordingly
	if [ /proc/$PPID/exe -ef /usr/bin/gnome-terminal ]; then
		for term in gnome-256color gnome-16color gnome; do
			if tput -T $term init >/dev/null 2>&1; then
				export TERM=$term
				break
			fi
		done
		unset term
	fi

	termcolor=$(tput colors 2>/dev/null)

	: ${PAGER:=more} ${termcolor:=-1}

	alias cp='cp -i'  # IMPORTANT!
	alias mv='mv -i'  # IMPORTANT!
	alias rm='rm -i'  # IMPORTANT!

	alias -- -='cd -'
	alias ..='cd ..'
	alias dirs='dirs -v'
	alias f='fg'
	alias gr='grep'
	alias he='head'
	alias j='jobs'
	alias la='ls -a'
	alias le='$PAGER'
	alias ll='ls -l'
	alias lla='ll -a'
	alias r='fc -s'
	alias so='sort'
	alias ta='tail'
	alias tree='tree -C'
	alias ci='vcs_ci' log='vcs_log' st='vcs_st' up='vcs_up'

	if [ "$termcolor" -ge 8 ] && ls --color=tty -d . >/dev/null 2>&1; then
		alias ls='ls --color=tty'
	fi

	if command -v nkf >/dev/null 2>&1; then
		case "${LC_ALL:-${LC_CTYPE:-${LANG:-}}}" in
			*utf8* |*utf-8* |*UTF8* |*UTF-8* )
				alias nkf='nkf -xw --no-best-fit-chars';;
			*eucjp*|*euc-jp*|*EUCJP*|*EUC-JP*)
				alias nkf='nkf -xe';;
		esac
	fi

	if command -v vim >/dev/null 2>&1; then
		alias vi='vim'
		alias vl='vimless'
	fi

	if command -v gnome-open >/dev/null 2>&1; then
		alias go='gnome-open'
	fi

	if [ ${SHLVL:-0} -gt 1 ]; then
		shlvl=$SHLVL
	else
		shlvl=
	fi
	if [ "$termcolor" -ge 8 ]; then
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
		vcsinfo='${VCS_INFO:+\[\e[0;36m\]$VCS_INFO'$bold' }'
		PS1=$uc'\u'$hc'@\h'$bold' \W '$vcsinfo$shlvl'b\$'$normal' '
		PS2=$gc'>'$normal' '
		PS1='\[\e]0;\u@\h:\w\a\]'$PS1
		ssh() {
			if [ -t 1 ]; then printf '\033]0;ssh %s\a' "$*"; fi
			command ssh "$@"
		}
	else
		vcsinfo='${VCS_INFO:+$VCS_INFO }'
		PS1='\u@\h \W '$vcsinfo$shlvl'b\$ '
		PS2='> '
	fi
	HISTCONTROL=ignoreboth
	unset shlvl uc gc hc bold normal vcsinfo

	# tricks to show VCS info in the prompt
	_update_vcs_info() {
		if [ -d .svn ]; then
			VCS_INFO=svn
			return
		fi
		VCS_INFO=$(
			while true; do
				if [ -d .hg ]; then
					printf 'hg:'
					exec hg branch 2>/dev/null
				elif [ -d .git ]; then
					printf 'git:'
					exec git branch >(grep '^\*' | cut -c 3-) 2>/dev/null
				fi
				if [ / -ef . ] || [ . -ef .. ]; then
					exit
				fi
				cd -P ..
			done
		)
		case "$VCS_INFO" in
			hg:default)        VCS_INFO='hg';;
			git: | git:master) VCS_INFO='git';;
		esac
	}
	PROMPT_COMMAND='_update_vcs_info'

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
	vcs_ci() {
		: ${VCS_INFO:?Not in version-controlled directory} &&
		command ${VCS_INFO%%:*} commit "$@"
	}
	vcs_log() {
		: ${VCS_INFO:?Not in version-controlled directory} &&
		command ${VCS_INFO%%:*} log "$@"
	}
	vcs_st() {
		: ${VCS_INFO:?Not in version-controlled directory} &&
		command ${VCS_INFO%%:*} status "$@"
	}
	vcs_up() {
		: ${VCS_INFO:?Not in version-controlled directory} &&
		command ${VCS_INFO%%:*} update "$@"
	}

	# sharing history
	#function share_history() {
	#	history -a
	#	history -c
	#	history -r
	#}
	#PROMPT_COMMAND="$PROMPT_COMMAND;share_history"
	#shopt -u histappend

	# use more as pager in dumb terminal
	if [ x"$TERM" = x"dumb" ]; then
		PAGER=more
	fi

esac

if [ -r ~/.bashrc_local ]; then
	. ~/.bashrc_local
fi
