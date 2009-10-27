# magicant's .zshrc

setopt autocd
setopt nolistbeep listpacked
setopt pushdignoredups
setopt histignoredups histignorespace sharehistory
setopt noclobber correct
setopt nohup
setopt promptsubst
setopt kshtypeset shwordsplit

bindkey    '\f'    redisplay
bindkey -e '\eOH'  beginning-of-line
bindkey -e '\e[1~' beginning-of-line
bindkey -e '\eOF'  end-of-line
bindkey -e '\e[4~' end-of-line
bindkey -e '\e[3~' delete-char
bindkey -v '\eOH'  vi-beginning-of-line
bindkey -v '\e[1~' vi-beginning-of-line
bindkey -v '\eOF'  vi-end-of-line
bindkey -v '\e[4~' vi-end-of-line
bindkey -v '\e[3~' vi-delete-char
bindkey -v '\e[2~' vi-insert
bindkey -a '\eOH'  vi-beginning-of-line
bindkey -a '\e[1~' vi-beginning-of-line
bindkey -a '\eOF'  vi-end-of-line
bindkey -a '\e[4~' vi-end-of-line
bindkey -a '\e[3~' vi-delete-char
bindkey -e

autoload -U compinit
compinit

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
: ${PAGER:=more}

alias cp='cp -i'  # IMPORTANT!
alias mv='mv -i'
alias rm='rm -i'

alias -- -='cd -'
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
alias -g G='|grep'
alias -g H='|head'
alias -g L='|$PAGER'
alias -g N='>/dev/null 2>&1' N1='>/dev/null' N2='2>/dev/null'
alias -g S='|sort'
alias -g T='|tail'

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
	alias -g V='|vimless'
fi
if command -v gnome-open >/dev/null 2>&1; then
	alias go='gnome-open'
fi

HISTFILE=~/.zsh_history HISTSIZE=2000 SAVEHIST=1000
FCEDIT=${EDITOR:-vi}

autoload colors
colors
if [ -n "${SSH_CONNECTION-}" ] && [ -z "${SSH_LOCAL-}" ]; then
	hc='%{${fg_bold[yellow]}%}'
else
	hc='%{${fg_bold[green]}%}'
fi
if [ "$EUID" -eq 0 ]; then
	uc='%{${fg_bold[red]}%}' gc='%{${fg_bold[red]}%}'
else
	uc="$hc"                 gc='%{${fg_bold[default]}%}'
fi
PS1=$uc'%n'$hc'@%m%{${fg_bold[default]}%} %. ${VCS_INFO:+"%{${fg_no_bold[cyan]}%}${VCS_INFO}%{${fg_bold[default]}%} "}${SHLVL:/1}z%(!.#.$)%{$reset_color%} '
PS2=$gc'%_>%{$reset_color%} '
SPROMPT='Did you mean '%r'? [ynae] '
if [ "$termcolor" -ge 8 ]; then
	precmd () {
		printf '\033]0;%s@%s:%s\a' "$USER" "${HOST%%.*}" "${${PWD:/~/~}/#~\//~/}"
		_update_vcs_info
	}
	ssh () {
		if [ -t 1 ]; then printf '\033]0;ssh %s\a' "$*"; fi
		command ssh "$@"
	}
fi
unset uc gc hc esc bell

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

args()
if [ $# -gt 0 ]; then
	printf '%s\n' "$@"
fi
mkdircd() {
	mkdir -p "$@" && cd "$1"
}
vcs_ci() {
	${${VCS_INFO:?Not in version-controlled directory}%%:*} commit "$@"
}
vcs_log() {
	${${VCS_INFO:?Not in version-controlled directory}%%:*} log "$@"
}
vcs_st() {
	${${VCS_INFO:?Not in version-controlled directory}%%:*} status "$@"
}
vcs_up() {
	${${VCS_INFO:?Not in version-controlled directory}%%:*} update "$@"
}

# use more as pager in dumb terminal
if [ x"$TERM" = x"dumb" ]; then
	PAGER=more
fi

if [ -r ~/.zshrc_local ]; then
	. ~/.zshrc_local
fi

unset termcolor
