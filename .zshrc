. ~/.profile

autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%b '
setopt PROMPT_SUBST
PROMPT=$'\n%F{black}%n@%M%f\n%B%F{blue}%~%f%b %F{black}${vcs_info_msg_0_}%f\n$ '

export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

include() {
	test -f "$1" && . $1
}

include /opt/homebrew/etc/profile.d/z.sh

PLUGINS=""
PLUGIN_DIR="$HOME/.zsh_plugins"

plug() {
	case "$1" in
	   "add")
			if [ -z "$2" ] || [ -z "$3" ]; then
				echo "plug add expects 2 arguments"
			fi
			if [ -z "$PLUGINS" ]; then
				PLUGINS="$2"
			else
				PLUGINS="$PLUGINS:$2"
			fi
			NAME="$(echo "$2" | cut -d'/' -f2)"
			FILE="$PLUGIN_DIR/$NAME/$3"
			include $FILE
			unset NAME
			unset FILE
		;;
		"install")
			mkdir -p "$PLUGIN_DIR"
			for PLUG in $(echo "$PLUGINS" | tr ":" " "); do
				NAME="$(echo "$PLUG" | cut -d'/' -f2)"
				DIR="$PLUGIN_DIR/$NAME"
				if [ -d "$DIR" ]; then
					( cd "$DIR" && git pull origin HEAD )
				else
					( cd "$PLUGIN_DIR" && git clone "https://github.com/$PLUG" )
				fi
			done
			unset PLUG
			unset NAME
			unset DIR
		;;
		"ls")
			for PLUG in $(echo "$PLUGINS" | tr ":" " "); do
				echo "$PLUG"
			done
			unset PLUG
		;;
		*)
			echo "nope"
		;;
	esac
}

plug add "zsh-users/zsh-autosuggestions" "zsh-autosuggestions.zsh"
plug add "zsh-users/zsh-history-substring-search" "zsh-history-substring-search.zsh"
plug add "zsh-users/zsh-syntax-highlighting" "zsh-syntax-highlighting.zsh"
plug add "hlissner/zsh-autopair" "autopair.zsh"

bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
