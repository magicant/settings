#!/bin/sh

# $1 = pathname of target, relative to $PWD
# $2 = pathname of new symlink, relative to $HOME
makelink () {
	mkdir -p "$(dirname -- "$HOME/$2")"
	if [ -L "${HOME%/}/$2" ]; then
		echo "Symbolic link ~/$2 already exists"
	elif [ -d "${HOME%/}/$2" ]; then
		echo "~/$2 is a directory"
	elif ln -s "$(./relpath -- "$1" "${HOME%/}/$2")" "${HOME%/}/$2"; then
		echo "~/$2" "->" "$1"
	fi
}

set -Ceu
cd -- "$(dirname -- "$0")"
echo Home directory is "$HOME"
echo Settings directory is "$PWD"

makelink bashrc .bashrc
makelink colordiffrc .colordiffrc
if command -v dircolors >/dev/null 2>&1; then
	if TERM=xterm dircolors dircolors >/dev/null 2>&1; then
		makelink dircolors .dircolors
	else
		echo The dircolors command is too old to support your dircolors file
		echo Use the makedircolors script to fix it
	fi
fi
if [ -e "$HOME/.gitconfig" ]; then
	echo "File ~/.gitconfig already exists"
else
	{
		echo '[include]'
		echo "	path = $(./relpath -- gitconfig "$HOME/.gitconfig")"
	} >"$HOME/.gitconfig"
	echo "Created ~/.gitconfig"
fi
makelink inputrc .inputrc
makelink lesskey .lesskey
if command -v lesskey >/dev/null 2>&1; then
	if lesskey; then
		echo updated .less
	fi
fi
makelink lesspipe.sh bin/lesspipe.sh
makelink minttyrc .minttyrc
if ! [ $(PATH=$PATH:$PATH:$PATH which -a which 2>/dev/null | wc -l) -ge 3 ]
then
	makelink which bin/which
fi
if echo q | top -v 2>/dev/null | grep -q procps; then
	makelink toprc .toprc
fi
makelink relpath bin/relpath
makelink vimrc .vimrc
makelink vim .vim
makelink vimless bin/vimless
makelink vipipe bin/vipipe
makelink yashrc .yashrc
makelink zshrc .zshrc

if command -v xsel >/dev/null 2>&1; then
	if command -v pbcopy >/dev/null 2>&1; then
		:
	elif [ -e "$HOME/bin/pbcopy" ]; then
		echo "~/bin/pbcopy already exists"
	elif echo 'exec xsel -i -b "$@"' >"$HOME/bin/pbcopy" &&
		chmod a+x "$HOME/bin/pbcopy"; then
		echo "created ~/bin/pbcopy"
	fi
	if command -v pbpaste >/dev/null 2>&1; then
		:
	elif [ -e "$HOME/bin/pbpaste" ]; then
		echo "~/bin/pbpaste already exists"
	elif echo 'exec xsel -o -b "$@"' >"$HOME/bin/pbpaste" &&
		chmod a+x "$HOME/bin/pbpaste"; then
		echo "created ~/bin/pbpaste"
	fi
elif command -v xclip >/dev/null 2>&1; then
	if command -v pbcopy >/dev/null 2>&1; then
		:
	elif [ -e "$HOME/bin/pbcopy" ]; then
		echo "~/bin/pbcopy already exists"
	elif echo 'exec xclip -in -selection clipboard "$@"' >"$HOME/bin/pbcopy" &&
		chmod a+x "$HOME/bin/pbcopy"; then
		echo "created ~/bin/pbcopy"
	fi
	if command -v pbpaste >/dev/null 2>&1; then
		:
	elif [ -e "$HOME/bin/pbpaste" ]; then
		echo "~/bin/pbpaste already exists"
	elif echo 'exec xclip -out -selection clipboard "$@"' >"$HOME/bin/pbpaste" &&
		chmod a+x "$HOME/bin/pbpaste"; then
		echo "created ~/bin/pbpaste"
	fi
fi

if command -v vim >/dev/null 2>&1; then
	vim/setup.sh
	if command -v gvim >/dev/null 2>&1; then
		#makelink vimless bin/gvimless
		if [ -e "$HOME/bin/gvimless" ]; then
			echo "~/bin/gvimless already exists"
		else
			ln "$HOME/bin/vimless" "$HOME/bin/gvimless"
		fi
	fi
fi

mkdir -p "${HOME%/}/.ssh"
if [ -e "${HOME%/}/.ssh/config" ]; then
	echo "~/.ssh/config already exists"
else
	(umask go-w && cp ssh_config "${HOME%/}/.ssh/config")
	echo "Created ~/.ssh/config"
fi

chmod go-w "$HOME" "${HOME%/}/.ssh"

for file in .profile .yash_profile .hgrc
do
	if ! [ -r "${HOME%/}/$file" ]; then
		echo "WARNING: ~/$file does not exist or is not readable."
	fi
done
for file in .bash_profile .bash_login
do
	if [ -e "${HOME%/}/$file" ]; then
		echo "WARNING: ~/$file exists."
	fi
done
