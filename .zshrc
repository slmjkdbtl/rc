# wengwengweng

# prompt
setopt PROMPT_SUBST

git_prompt() {
	git rev-parse --is-inside-work-tree &> /dev/null || return 0
	echo -n $(git symbolic-ref --short HEAD 2> /dev/null)
	git diff-index --quiet HEAD -- &> /dev/null || echo -n "*"
}

PROMPT=$'\n'
PROMPT+="%F{black}%n@%m%f"
PROMPT+=$'\n'
PROMPT+="%F{yellow}%B%~%b%f"
PROMPT+=' %F{black}$(git_prompt)%f'
PROMPT+=$'\n'
PROMPT+="%F{white}%# %f"

# plugins
ZSH_PATH=~/.config/zsh

source $ZSH_PATH/highlight/zsh-syntax-highlighting.zsh
source $ZSH_PATH/autosuggestions/zsh-autosuggestions.zsh
source $ZSH_PATH/history-substring-search/zsh-history-substring-search.zsh

# alias
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

function gshow() {
	local fname=$(basename $1)
	local tpath=$TMPDIR$fname
	git show $1 > $tpath && nvim $tpath
	rm $tpath
}

