# wengwengweng

# prompt
PROMPT=$'\n'"%F{black}%n@%m%f"$'\n'"%F{yellow}%B%~%b%f"$'\n'"%F{white}%# %f"

# alias
alias v="nvim"
alias o="open"
alias f="open ."
alias dl="aria2c"
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
# TODO: setting EDITOR to nvim makes alt+backspace not working (?)
# export EDITOR=nvim
export VIMRUNTIME=$HOME/.conf/nvim

# local bin
export PATH=$HOME/.local/bin:$PATH

# plugins
ZSH_PATH=~/.config/zsh
source $ZSH_PATH/highlight/zsh-syntax-highlighting.zsh
source $ZSH_PATH/autosuggestions/zsh-autosuggestions.zsh
source $ZSH_PATH/history-substring-search/zsh-history-substring-search.zsh

# z
. /usr/local/etc/profile.d/z.sh

# llvm
export PATH=/usr/local/opt/llvm/bin:$PATH

# brew
export HOMEBREW_NO_AUTO_UPDATE=1

gshow() {
	local fname=$(basename $1)
	local tpath=$TMPDIR$fname
	git show $1 > $tpath && nvim $tpath
	rm $tpath
}

bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word

