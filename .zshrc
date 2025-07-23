. ~/.profile

precmd() {
	# TODO: support non xterm
	# set title to pwd
	printf "\e]0;%s\a" "$(pwd | sed "s|^$HOME|~|")"
	# set prompt git info
	prompt_git_info=""
	if command git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
		prompt_git_info="$(git rev-parse --abbrev-ref HEAD 2> /dev/null)"
		if ! git diff-index --quiet HEAD -- > /dev/null 2>&1; then
			prompt_git_info="$prompt_git_info*"
		fi
	fi
}

preexec() {
	# set title to current cmd
	echo -n "\e]0;${(z)1}\a"
}

setopt INC_APPEND_HISTORY
setopt CSH_NULL_GLOB
setopt PROMPT_SUBST
PROMPT=$'\n\x1b[2m%n@%M\x1b[0m\n%B\x1b[34m%~\x1b[0m%b \x1b[2m${prompt_git_info}\x1b[0m\n$ '
WORDCHARS='*?_-.~&;!#$%^"[](){}<>'
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000
SAVEHIST=$HISTSIZE

autoload -Uz compinit
compinit
zstyle ':completion:*' menu select

include() { [ -f "$1" ] && . $1; }
exists() { command -v "$1" > /dev/null 2>&1; }

split() { echo "$1" | tr "$2" " "; }
getn() { echo "$1" | cut -d"$2" -f"$3"; }

arrpush() {
	if [ -z "$1" ]; then
		echo "$2"
	else
		echo "$1$3$2"
	fi
}

ZSH_PLUGIN_DIR="$HOME/.zsh_plugins"

zsh_plugins=""
zsh_plugins_delim=":"

zplug() {
	case "$1" in
		"add")
			if [ -z "$2" ]; then
				echo "zplug add <repo> <file>"
				return
			fi
			zsh_plugins=$(arrpush "$zsh_plugins" "$2" "$zsh_plugins_delim")
			if [ -n "$3" ]; then
				name=$(getn "$2" "/" 2)
				. "$ZSH_PLUGIN_DIR/$name/$3"
			fi
			unset name
		;;
		"install"|"update")
			mkdir -p "$ZSH_PLUGIN_DIR"
			for plug in $(split "$zsh_plugins" "$zsh_plugins_delim"); do
				name=$(getn "$plug" "/" 2)
				dir="$ZSH_PLUGIN_DIR/$name"
				if [ -d "$dir" ]; then
					( cd "$dir" && git pull origin HEAD )
				else
					( cd "$ZSH_PLUGIN_DIR" && git clone "https://github.com/$plug" )
				fi
			done
			unset plug
			unset name
			unset dir
		;;
		"ls")
			for plug in $(split "$zsh_plugins" "$zsh_plugins_delim"); do
				echo "$plug"
			done
			unset plug
		;;
		*)
			echo "zplug install"
			echo "zplug ls"
		;;
	esac
}

zplug add "zsh-users/zsh-autosuggestions" "zsh-autosuggestions.zsh"
zplug add "zsh-users/zsh-syntax-highlighting" "zsh-syntax-highlighting.zsh"
zplug add "hlissner/zsh-autopair" "autopair.zsh"

bindkey -e
bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word

# https://unix.stackexchange.com/a/691482/368625
for dir (up down) {
	autoload $dir-line-or-beginning-search
	zle -N $dir-line-or-beginning-search
	key=$terminfo[kcu$dir[1]1]
	for key ($key ${key/O/[})
	bindkey $key $dir-line-or-beginning-search
}

if exists zoxide; then
	eval "$(zoxide init zsh)"
fi
