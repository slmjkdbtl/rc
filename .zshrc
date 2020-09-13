# wengwengweng

autoload -Uz compinit && compinit

# prompt
setopt PROMPT_SUBST

function git-prompt() {
	# if git
	git rev-parse --is-inside-work-tree &> /dev/null || return 0
	# branch
	echo -n $(git symbolic-ref --short HEAD 2> /dev/null)
	# modified
	git diff-index --quiet HEAD -- &> /dev/null || echo -n "*"
}

RPROMPT=""
PROMPT=""
PROMPT+=$'\n'
# user@host
PROMPT+="%F{black}%n@%m%f"
PROMPT+=$'\n'
# path
PROMPT+="%F{yellow}%B%~%b%f"
# git
PROMPT+=' %F{black}$(git-prompt)%f'
PROMPT+=$'\n'
# %
PROMPT+="%F{white}%# %f"

# plugins
ZSH_PATH=~/.config/zsh

source $ZSH_PATH/highlight/zsh-syntax-highlighting.zsh
source $ZSH_PATH/history-substring-search/zsh-history-substring-search.zsh

# alias
alias ..="cd .."
alias ....="cd ../.."
alias v="nvim"
alias o="open"
alias f="open ."
alias dl="aria2c"
alias lg="lazygit"
alias size="du -sch"
alias ydl="youtube-dl --format mp4 -o '%(title)s.%(ext)s' -i --no-playlist"
alias ydll="youtube-dl --format mp4 -o '%(title)s.%(ext)s' -i --yes-playlist"
alias ydlm="youtube-dl -x --audio-format mp3 -o '%(title)s.%(ext)s' -i --no-playlist"
alias ydlml="youtube-dl -x --audio-format mp3 -o '%(title)s.%(ext)s' -i --yes-playlist"
alias ip="ifconfig | grep 'inet.*broadcast' | awk '{print \$2}'"
alias extip="curl ifconfig.co"

# env
export BROWSER=open
export PAGER=less
export EDITOR=nvim
export VIMRUNTIME=$HOME/.conf/nvim

# local bin
export PATH=$HOME/.local/bin:$PATH

# git
export FILTER_BRANCH_SQUELCH_WARNING=1

# z
. /usr/local/etc/profile.d/z.sh

# llvm
export PATH=/usr/local/opt/llvm/bin:$PATH

# brew
export HOMEBREW_NO_AUTO_UPDATE=1

# show a file in history in editor
function gshow() {
	local fname=$(basename $1)
	local tpath=$TMPDIR$fname
	git show $1 > $tpath && $EDITOR $tpath
	rm $tpath
}

# abbr
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

abbr ga='git add -A'
abbr gs='git status'
abbr gc='git commit -m'
abbr gp='git push'

