# wengwengweng

abbrs=()

function abbr() {
	alias $1
	abbrs+=($1)
}

function expand-abbr() {
	if [[ " ${abbrs[*]}" == *"$LBUFFER"* ]]; then
		zle _expand_alias
		zle expand-word
	fi
	zle magic-space
}

zle -N expand-abbr

bindkey ' ' expand-abbr
bindkey '^ ' magic-space
bindkey -M isearch " " magic-space

