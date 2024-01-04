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

. ~/.local/bin/plug
plug add "zsh-users/zsh-autosuggestions" "zsh-autosuggestions.zsh"
plug add "zsh-users/zsh-history-substring-search" "zsh-history-substring-search.zsh"
plug add "zsh-users/zsh-syntax-highlighting" "zsh-syntax-highlighting.zsh"
plug add "hlissner/zsh-autopair" "autopair.zsh"

bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
