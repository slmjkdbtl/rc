# wengwengweng

autoload -Uz compinit && compinit

# plugins
ZSHPATH="$HOME/.config/zsh"

for f in $ZSHPATH/*.zsh; do
	source $f
done

# settings
setopt PROMPT_SUBST
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY
setopt NULL_GLOB
setopt HIST_IGNORE_ALL_DUPS

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

HISTSIZE=65536
SAVEHIST=65536
HISTFILE=$HOME/.zhistory
WORDCHARS=

# env
export BROWSER=open
export PAGER=less
export EDITOR=nvim

# brew
export PATH="/opt/homebrew/bin/:$PATH"

# local
export PATH="$HOME/.scripts:$PATH"

# sbin
export PATH="/opt/homebrew/sbin:$PATH"

# git
export FILTER_BRANCH_SQUELCH_WARNING=1

# broot
source ~/.config/broot/launcher/bash/br

# z
case $(uname) in
"Darwin")
	source /opt/homebrew/etc/profile.d/z.sh
	;;
*)
	source /usr/local/share/z/z.sh
	;;
esac

# cargo
export PATH="$HOME/.cargo/bin:$PATH"

# llvm
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"

# brew
export HOMEBREW_NO_AUTO_UPDATE=1

# alias
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias e="$EDITOR"
alias o="open"
alias f="open ."
alias dl="aria2c"
alias la='ls -lah'
alias lsize="du -chs * .* | sort -h"
alias ydl="youtube-dl --format mp4 -o '%(title)s.%(ext)s' -i --no-playlist"
alias ydll="youtube-dl --format mp4 -o '%(title)s.%(ext)s' -i --yes-playlist"
alias ydlm="youtube-dl -x --audio-format mp3 -o '%(title)s.%(ext)s' -i --no-playlist"
alias ydlml="youtube-dl -x --audio-format mp3 -o '%(title)s.%(ext)s' -i --yes-playlist"
alias ip="ifconfig | grep 'inet.*broadcast' | awk '{print \$2}'"
alias extip="curl ifconfig.co"
alias playraw="ffplay -ar 8000 -ac 1 -f u8 -nodisp -"
alias zshrc="$EDITOR ${(%):-%N}"
alias zshrcs="source ${(%):-%N}"

# abbr
abbr ga="git add -A"
abbr gs="git status"
abbr gc="git commit -m"
abbr gp="git push"
abbr gcl="git clone"
abbr gpl="git pull"

