# magicant's .zshrc

setopt autocd
setopt nolistbeep listpacked
setopt pushdignoredups
setopt histignoredups histignorespace sharehistory
setopt noclobber correct
setopt nohup
setopt promptsubst
setopt kshtypeset shwordsplit

bindkey -e
autoload -U compinit
compinit

termcolor=$(tput colors 2>/dev/null)
: ${PAGER:=more}

alias cp='cp -i'  # IMPORTANT!
alias mv='mv -i'
alias rm='rm -i'

alias -- -='cd -'
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
alias -g G='|grep'
alias -g H='|head'
alias -g L='|$PAGER'
alias -g N='>/dev/null 2>&1'
alias -g S='|sort'
alias -g T='|tail'

if [ "$termcolor" -ge 8 ] && ls --color=tty -d . >/dev/null 2>&1; then
	alias ls='ls --color=tty'
fi
if command -v nkf >/dev/null 2>&1; then
	case "${LC_ALL:-${LC_CTYPE:-${LANG:-}}}" in
		*utf8* |*utf-8* |*UTF8* |*UTF-8* ) alias nkf='nkf -w';;
		*eucjp*|*euc-jp*|*EUCJP*|*EUC-JP*) alias nkf='nkf -e';;
	esac
fi
if command -v vim >/dev/null 2>&1; then
	alias vi='vim'
	alias vl='vimless'
	alias -g V='|vimless'
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
PS1=$uc'%n'$hc'@%m%{${fg_bold[default]}%} %. ${SHLVL:/1}z%(!.#.$)%{$reset_color%} '
PS2=$gc'%_>%{$reset_color%} '
SPROMPT='Did you mean '%r'? [ynae] '
if [ "$termcolor" -ge 8 ]; then
	precmd () {
		printf '\033]0;%s@%s:%s\a' "$USER" "${HOST%%.*}" "${${PWD:/~/~}/#~\//~/}"
	}
fi
unset uc gc hc esc bell

args()
if [ $# -gt 0 ]; then
	printf '%s\n' "$@"
fi
mkdircd() {
	mkdir -p "$@" && cd "$1"
}

if [ -r ~/.zshrc_local ]; then
	. ~/.zshrc_local
fi

unset termcolor
