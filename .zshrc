# wengwengweng

autoload -Uz compinit && compinit

# plugins
ZSHPATH=$HOME/.config/zsh

for f in $ZSHPATH/*.zsh; do
	source $f
done

# prompt
setopt promptsubst

RPROMPT=
PROMPT=
PROMPT+=$'\n'
# user@host
PROMPT+="%F{black}%n@%m%f"
PROMPT+=$'\n'
# path
PROMPT+="%F{green}%B%~%b%f"
# git
PROMPT+=' %F{black}$(git-prompt)%f'
PROMPT+=$'\n'
# %/#
PROMPT+="%F{yellow}%# %f"

# history
HISTSIZE=2048
SAVEHIST=2048
HISTFILE=$HOME/.zhistory

setopt appendhistory
setopt sharehistory
setopt incappendhistory

WORDCHARS=

# alias
alias ..="cd .."
alias ....="cd ../.."
alias v="nvim"
alias o="open"
alias f="open ."
alias dl="aria2c"
alias lg="lazygit"
alias la='ls -lah | grep "^d"&& ls -lah | grep "^-" && ls -lah | grep "^l"'
alias lsize="du -chs * .* | sort -h"
alias ydl="youtube-dl --format mp4 -o '%(title)s.%(ext)s' -i --no-playlist"
alias ydll="youtube-dl --format mp4 -o '%(title)s.%(ext)s' -i --yes-playlist"
alias ydlm="youtube-dl -x --audio-format mp3 -o '%(title)s.%(ext)s' -i --no-playlist"
alias ydlml="youtube-dl -x --audio-format mp3 -o '%(title)s.%(ext)s' -i --yes-playlist"
alias ip="ifconfig | grep 'inet.*broadcast' | awk '{print \$2}'"
alias extip="curl ifconfig.co"

# abbr
abbr ga="git add -A"
abbr gs="git status"
abbr gc="git commit -m"
abbr gp="git push"
abbr gcl="git clone"
abbr gpl="git pull"

# env
export BROWSER=open
export PAGER=less
export EDITOR=nvim
export VIMRUNTIME=$HOME/.conf/nvim

# local
export PATH=$HOME/.scripts:$PATH
export PATH=$HOME/.bin:$PATH

# cargo
export PATH=$HOME/.cargo/bin:$PATH

# git
export FILTER_BRANCH_SQUELCH_WARNING=1

# z
case $(uname) in
"Darwin")
	. /usr/local/etc/profile.d/z.sh
	;;
"Linux")
	. /usr/local/share/z/z.sh
	;;
"FreeBSD")
	. /usr/local/share/z/z.sh
	;;
esac

# emscripten
export PATH=$HOME/.emsdk/upstream/emscripten/:$PATH

# llvm
export PATH=/usr/local/opt/llvm/bin:$PATH

# brew
export HOMEBREW_NO_AUTO_UPDATE=1

