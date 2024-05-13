export HOMEBREW_NO_AUTO_UPDATE=1

exists() { command -v "$1" > /dev/null 2>&1; }

export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

if exists /opt/homebrew/bin/brew; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
	export CFLAGS="-I$HOMEBREW_PREFIX/include"
	export LDFLAGS="-L$HOMEBREW_PREFIX/lib"
fi

if exists python3; then
	export PATH="$(python3 -m site --user-base)/bin:$PATH"
fi

export EDITOR="vim"
export BROWSER="open"
export PAGER="less"

alias ~="cd ~"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias e='$EDITOR'
alias se='sudo -E $EDITOR'
alias o="open"
alias f="open ."
alias lsize="du -chs * .* | sort -h"
alias disk="df -h ."
alias uptext="curl -F 'f:1=<-' ix.io"
alias ip="curl ifconfig.co"
alias playraw="ffplay -ar 8000 -ac 1 -f u8 -nodisp -"
alias weather="curl 'wttr.in?m'"
alias dnsflush="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"
alias dsclean="find . -name '.DS_Store' -print -delete"
alias opengate="sudo spctl --master-disable"
alias dl="aria2c -x 16 -s 16 -k 1M"
alias gs="git status"
alias ga="git add -A"
alias gc="git commit -m"
alias gp="git push"
alias gb="git branch"
alias gr="git remote"
alias gd="git diff"
alias gsw="git switch"
alias gcl="git clone"
alias gpl="git pull"
alias grv="gh repo view --web"
alias toupper="tr '[:lower:]' '[:upper:]'"
alias tolower="tr '[:upper:]' '[:lower:]'"
alias serve="darkhttpd"
alias python="python3"
alias ffmpeg="ffmpeg -hide_banner"
alias map="xargs -n1"
alias stfu="osascript -e 'set volume output muted true'"
alias pumpitup="osascript -e 'set volume output volume 100'"
alias reload='exec $SHELL -l'
alias path='echo -e ${PATH//:/\\n}'
alias ase="/Applications/Aseprite.app/Contents/MacOS/aseprite --batch"
alias chrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"

ytdlp_args="--external-downloader aria2c --external-downloader-args '-x 16 -s 16 -k 1M' --cookies ~/files/cookies.txt"
alias ydl="yt-dlp --format mp4 -o '%(title)s.%(ext)s' -i --no-playlist $ytdlp_args"
alias ydll="yt-dlp --format mp4 -o '%(title)s.%(ext)s' -i --yes-playlist $ytdlp_args"
alias ydlm="yt-dlp -x --audio-format mp3 -o '%(title)s.%(ext)s' -i --no-playlist $ytdlp_args"
alias ydlmc="yt-dlp -x --audio-format mp3 --split-chapters -o '%(chapter)s.%(ext)s' -i --no-playlist $ytdlp_args"
alias ydlml="yt-dlp -x --audio-format mp3 -o '%(title)s.%(ext)s' -i --yes-playlist $ytdlp_args"
unset ytdlp_args

localip() {
	if exists ipconfig; then
		ipconfig getifaddr en0
	elif exists hostname; then
		hostname -I
	fi
}

PS1='\n\u@\H\n\w\n$ '
