# magicant's .bashrc
# This rc file can be shared with root.
# This file may be used to initialize a non-interactive shell.

if [ -r /etc/bashrc ]; then
	alias alias=: 2>/dev/null
	. /etc/bashrc
	\unalias \alias \unalias 2>/dev/null
elif [ -r /etc/bash.bashrc ]; then
	alias alias=: 2>/dev/null
	. /etc/bash.bashrc
	\unalias \alias \unalias 2>/dev/null
fi

# Interactive?
case $- in *i*)

	# if the shell is executed in a terminal emulator, set $TERM accordingly
	if [ -r "${SETTINGSDIR:-$HOME/.settings}/setterm" ]; then
		case $(ps -o comm= -p $PPID 2>/dev/null) in
			xterm | */xterm)
				TERM=xterm-256color
				. "${SETTINGSDIR:-$HOME/.settings}/setterm"
				;;
			gnome-terminal | */gnome-terminal )
				TERM=gnome-256color
				. "${SETTINGSDIR:-$HOME/.settings}/setterm"
				;;
		esac
	fi

	filter() {
		sed -e 's;\\;\\\\;g' -e 's;;\\e;g' -e 's;;\\a;g' -e 's;\n;\\n;g'
	}
	tputn() {
		tput "$@" 2>/dev/null; echo
	}
	termcolor=$(tput colors 2>/dev/null)
	case "$TERM" in
		xterm|xterm[+-]*|gnome|gnome[+-]*|putty|putty[+-]*)
			tsl='\e]0;' fsl='\e\\' ;;
		cygwin)
			tsl='\e];' fsl='\a' ;;
		*)
			tsl=$(tputn tsl 0 | filter) fsl=$(tputn fsl | filter) ;;
	esac

	: ${PAGER:=more} ${termcolor:=-1}

	alias cp='cp -i'  # IMPORTANT!
	alias mv='mv -i'  # IMPORTANT!
	alias rm='rm -i'  # IMPORTANT!

	alias -- -='cd -'
	alias ..='cd ..'
	alias _vcs='${VCS_INFO%%:*}'
	alias ci='_vcs commit'
	alias dirs='dirs -v'
	alias f='fg'
	alias g='grep'
	alias h='head'
	alias j='jobs'
	alias la='ls -a'
	alias l='$PAGER'
	alias ll='ls -l'
	alias lla='ll -a'
	alias log='_vcs log'
	alias m='make'
	alias r='fc -s'
	alias s='sort'
	alias st='_vcs status'
	alias t='tail'
	alias up='_vcs update'

	if [ "$termcolor" -ge 8 ] && ls --color=tty -d . >/dev/null 2>&1; then
		alias ls='ls --color=tty'
	fi

	if command -v tree >/dev/null 2>&1; then
		alias tree='tree -C'
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
		alias vi='vim' view='vim -R' vl='vimless'
	fi

	if command -v xdg-open >/dev/null 2>&1; then
		alias o='xdg-open'
	fi

	if [ ${SHLVL:-0} -gt 1 ]; then
		shlvl=$SHLVL
	else
		shlvl=
	fi
	if [ "$termcolor" -ge 8 ]; then
		color() {
			( tputn setaf $1 || tputn setf $2 ) | filter
		}
		bold='\['"$(tputn bold | filter)"'\]'   # start bold font
		normal='\['"$(tputn sgr0 | filter)"'\]' # reset color & style
		normalc='\['"$(tputn op | filter)"'\]'  # reset color
		if [ -n "${SSH_CONNECTION}" ] && [ -z "${SSH_LOCAL-}" ]; then
			hc='\['$(color 3 6)'\]'   # yellow for remote host
		else
			hc='\['$(color 2 2)'\]'   # green for local host
		fi
		if [ "$EUID" -eq 0 ]; then
			uc='\['$(color 1 4)'\]'   # red for root
			gc=$uc
		else
			uc=$hc                    # normal
			hc=
			gc=
		fi
		vcs='${VCS_INFO:+'$normal'\['$(color 6 3)'\]$VCS_INFO'$normal$bold' }'
		PS1=$bold$uc'\u'$hc'@\h'$normalc' \W '$vcs$shlvl'b\$'$normal' '
		PS2=$bold$gc'>'$normal' '
	else
		vcs='${VCS_INFO:+$VCS_INFO }'
		PS1='\u@\h \W '$vcs$shlvl'b\$ '
		PS2='> '
	fi
	if [ "${tsl-}" ] && [ "${fsl-}" ]; then
		PS1='\['$tsl'\u@\h:\w'$fsl'\]'$PS1
		_tsl=$(printf '%s\n' "$tsl" | sed 's;%;%%;g')
		_fsl=$(printf '%s\n' "$fsl" | sed 's;%;%%;g')
		ssh() {
			if [ -t 1 ]; then printf "$_tsl"'ssh %s'"$_fsl" "$*"; fi
			command ssh "$@"
		}
	fi
	unset tsl fsl shlvl uc gc hc bold normal vcs
	unset -f filter tputn color

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
					exec cat .hg/branch 2>/dev/null
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
			hg:  | hg:default) VCS_INFO='hg';;
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
	HISTFILE=~/.bash_history HISTSIZE=2000 HISTFILESIZE=1000
	HISTCONTROL=ignoreboth

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

	# use more as pager in dumb terminal
	if [ x"$TERM" = x"dumb" ]; then
		PAGER=more
	fi

esac

if [ -r ~/.bashrc_local ]; then
	. ~/.bashrc_local
fi
