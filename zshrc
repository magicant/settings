# magicant's .zshrc

setopt autocd
setopt nolistbeep listpacked
setopt pushdignoredups
setopt histignoredups histignorespace sharehistory
setopt noclobber correct
setopt nohup
setopt promptsubst nopromptbang promptpercent
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

autoload -Uz compinit
compinit

# if the shell is executed in a terminal emulator, set $TERM accordingly
if [ /proc/$PPID/exe -ef /usr/bin/xterm ]; then
	terms=(xterm-256color xterm-16color xterm)
elif [ /proc/$PPID/exe -ef /usr/bin/gnome-terminal ]; then
	terms=(gnome-256color gnome-16color gnome)
else
	terms=()
fi
for term in $terms; do
	if tput -T $term init >/dev/null 2>&1; then
		export TERM=$term
		break
	fi
done
unset term terms

termcolor=$(tput colors 2>/dev/null)
: ${PAGER:=more} ${termcolor:=-1}

alias cp='cp -i'  # IMPORTANT!
alias mv='mv -i'
alias rm='rm -i'

alias -- -='cd -'
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
if command -v xdg-open >/dev/null 2>&1; then
	alias op='xdg-open'
fi

HISTFILE=~/.zsh_history HISTSIZE=2000 SAVEHIST=1000
FCEDIT=${EDITOR:-vi}

autoload -Uz vcs_info
zstyle ':vcs_info:*' formats       '%s:%b'
zstyle ':vcs_info:*' actionformats '%s:%b!%a'

#autoload -Uz colors
#colors

if [ -n "${SSH_CONNECTION-}" ] && [ -z "${SSH_LOCAL-}" ]; then
	hc='%F{yellow}'
else
	hc='%F{green}'
fi
if [ "$EUID" -eq 0 ]; then
	uc='%F{red}' gc='%F{red}'
else
	uc="$hc"     gc=''        hc=''
fi
PS1=$uc'%B%n'$hc'@%m%f %. ${SHLVL:/1}z%(!.#.$)%f%b '
PS2=$gc'%B%_>%f%b '
RPROMPT='${vcs_info_msg_0_:+%b%F{cyan\}$vcs_info_msg_0_%f%B}'
SPROMPT='Did you mean "%r"? [ynae] '
unset uc gc hc esc bell

_tsl=$(tput tsl 2>/dev/null |
	sed -e 's;\\;\\\\;g' -e 's;;\\033;g' -e 's;;\\a;g' -e 's;%;%%;g')
_fsl=$(tput fsl 2>/dev/null |
	sed -e 's;\\;\\\\;g' -e 's;;\\033;g' -e 's;;\\a;g' -e 's;%;%%;g')
if ! [ "$_tsl" ] || ! [ "$_fsl" ]; then
	case "$TERM" in
		xterm|xterm[+-]*|gnome|gnome[+-]*|putty|putty[+-]*)
			_tsl='\033]0;' _fsl='\a' ;;
	esac
fi
if [ "$_tsl" ] && [ "$_fsl" ]; then
	precmd () {
		printf "$_tsl"'%s@%s:%s'"$_fsl" \
			"$USER" "${HOST%%.*}" "${${PWD:/~/~}/#~\//~/}"
		LC_ALL=en_US.UTF-8 vcs_info 2>/dev/null
	}
	ssh () {
		if [ -t 1 ]; then printf "$_tsl"'ssh %s'"$_fsl" "$*"; fi
		command ssh "$@"
	}
fi

args()
if [ $# -gt 0 ]; then
	printf '%s\n' "$@"
fi
mkdircd() {
	mkdir -p "$@" && cd "$1"
}
vcs_ci() {
	${${vcs_info_msg_0_:?Not in version-controlled directory}%%:*} commit "$@"
}
vcs_log() {
	${${vcs_info_msg_0_:?Not in version-controlled directory}%%:*} log "$@"
}
vcs_st() {
	${${vcs_info_msg_0_:?Not in version-controlled directory}%%:*} status "$@"
}
vcs_up() {
	${${vcs_info_msg_0_:?Not in version-controlled directory}%%:*} update "$@"
}

# use more as pager in dumb terminal
if [ x"$TERM" = x"dumb" ]; then
	PAGER=more
fi

if [ -r ~/.zshrc_local ]; then
	. ~/.zshrc_local
fi

unset termcolor
