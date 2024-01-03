HOMEBREW_HOME=/opt/homebrew
export HOMEBREW_NO_AUTO_UPDATE=1
export PATH=$HOMEBREW_HOME/bin:$PATH
export PATH=$HOMEBREW_HOME/sbin:$PATH
export PATH=$HOMEBREW_HOME/opt/llvm/bin:$PATH
export TLDR_AUTO_UPDATE_DISABLED=1
export PATH=$HOME/.cargo/bin:$PATH
export GOPATH=$HOME/.go
export PATH=$GOPATH/bin:$PATH
export PATH=$HOME/.local/bin:$PATH

export CFLAGS=-I$HOMEBREW_HOME/include:$CFLAGS
export LDFLAGS=-L$HOMEBREW_HOME/lib:$LDFLAGS

export EDITOR="vim"
export BROWSER="open"
export PAGER="less"

eval "$(jump shell --bind=z)"

alias e="$EDITOR"
alias o="open"
alias f="open ."
alias lsize="du -chs * .* | sort -h"
alias disk="df -h ."
alias sudo="sudo -E"
ytdlparg="--external-downloader aria2c --external-downloader-args '-x 16 -s 16 -k 1M' --cookies ~/files/cookies.txt"
alias ydl="yt-dlp --format mp4 -o '%(title)s.%(ext)s' -i --no-playlist $ytdlparg"
alias ydll="yt-dlp --format mp4 -o '%(title)s.%(ext)s' -i --yes-playlist --playlist-reverse $ytdlparg"
alias ydlm="yt-dlp -x --audio-format mp3 -o '%(title)s.%(ext)s' -i --no-playlist $ytdlparg"
alias ydlmc="yt-dlp -x --audio-format mp3 --split-chapters -o '%(chapter)s.%(ext)s' -i --no-playlist $ytdlparg"
alias ydlml="yt-dlp -x --audio-format mp3 -o '%(title)s.%(ext)s' -i --yes-playlist $ytdlparg"
alias ase="/Applications/Aseprite.app/Contents/MacOS/aseprite --batch"
alias toix="curl -F 'f:1=<-' ix.io"
alias localip="ipconfig getifaddr en0"
alias extip="curl ifconfig.co"
alias playraw="ffplay -ar 8000 -ac 1 -f u8 -nodisp -"
alias weather="curl 'wttr.in?m'"
alias dnsclear="sudo killall -HUP mDNSResponder"
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

PS1='\n\u@\h\n\w\n$ '
