. ~/.profile

precmd() {
	# set title to pwd
	echo -n "\e]0;${PWD/#$HOME/~}\a"
	git_info=""
	if command git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
		git_info="$(git rev-parse --abbrev-ref HEAD 2> /dev/null)"
		if ! git diff-index --quiet HEAD -- > /dev/null 2>&1; then
			git_info="$git_info*"
		fi
	fi
}

preexec() {
	# set title to current cmd
	echo -n "\e]0;${(z)1}\a"
}

setopt PROMPT_SUBST
PROMPT=$'\n%F{black}%n@%M%f\n%B%F{blue}%~%f%b %F{black}${git_info}%f\n$ '
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

include() {
	test -f "$1" && . $1
}

include /opt/homebrew/etc/profile.d/z.sh

. ~/.local/bin/plug
plug add "zsh-users/zsh-autosuggestions" "zsh-autosuggestions.zsh"
plug add "zsh-users/zsh-history-substring-search" "zsh-history-substring-search.zsh"
plug add "zsh-users/zsh-syntax-highlighting" "zsh-syntax-highlighting.zsh"
plug add "hlissner/zsh-autopair" "autopair.zsh"

bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
