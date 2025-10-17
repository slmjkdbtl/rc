export EDITOR="vim"
export FCEDIT="$EDITOR"
export SYSTEMD_EDITOR="$EDITOR"
export BROWSER="open"
export PAGER="less"
export LANG="en_US.UTF-8"

export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.rc/scripts:$PATH"

exists() { command -v "$1" > /dev/null 2>&1; }

if exists /opt/homebrew/bin/brew; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
	export HOMEBREW_NO_AUTO_UPDATE=1
	export CFLAGS="$CFLAGS -I$HOMEBREW_PREFIX/include"
	export CPPFLAGS="$CPPFLAGS -I$HOMEBREW_PREFIX/include"
	export CXXFLAGS="$CXXFLAGS -I$HOMEBREW_PREFIX/include"
	export LDFLAGS="$LDFLAGS -L$HOMEBREW_PREFIX/lib"
fi

export PATH="$HOMEBREW_PREFIX/opt/llvm/bin:$PATH"
export WINEPATH="$HOMEBREW_PREFIX/opt/mingw-w64/toolchain-x86_64/x86_64-w64-mingw32/bin"
export ANDROID_NDK_HOME="$HOMEBREW_PREFIX/share/android-ndk"

alias ~='cd $HOME'
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias e='$EDITOR'
alias se='sudo -E $EDITOR'
alias o="open"
alias f="open ."
alias l="ls -la"
alias lsize="du -chs * .* | sort -h"
alias disk="df -h ."
alias uptext="curl -F 'f:1=<-' ix.io"
alias ip="curl ifconfig.co"
alias localip="ipconfig getifaddr en0"
alias playraw="ffplay -ar 8000 -ac 1 -f u8 -nodisp -"
alias weather="curl 'wttr.in?m'"
alias dnsflush="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"
alias dsclean="find . -name '.DS_Store' -print -delete"
alias opengate="sudo spctl --master-disable"
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
alias reload='exec $SHELL -l'
alias path='echo -e ${PATH//:/\\n}'
alias clearbrewcache='rm -rf $(brew --cache)/*'
alias ase="/Applications/Aseprite.app/Contents/MacOS/aseprite --batch"
alias chrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"

alias dl="aria2c"
alias dv="yt-dlp -f 'bv[ext=mp4][height<=720][vcodec*=avc]+ba[ext=m4a]/b[ext=mp4][height<=720][vcodec*=avc]/b' -o '%(title)s.%(ext)s' --no-playlist"
alias dvl="yt-dlp -f 'bv[ext=mp4][height<=720][vcodec*=avc]+ba[ext=m4a]/b[ext=mp4][height<=720][vcodec*=avc]/b' --yes-playlist"
alias dm="yt-dlp -x --audio-format mp3 -o '%(title)s.%(ext)s' --no-playlist"
alias dml="yt-dlp -x --audio-format mp3 -o '%(title)s.%(ext)s' --yes-playlist"
alias dmc="yt-dlp -x --audio-format mp3 --split-chapters -o '%(chapter)s.%(ext)s' --no-playlist"
alias ds="yt-dlp --all-subs --convert-subs srt --skip-download --no-playlist"
alias dsl="yt-dlp --all-subs --convert-subs srt --skip-download --yes-playlist"
alias dt="yt-dlp --skip-download --write-thumbnail --convert-thumbnails jpg --no-playlist"
alias di="gallery-dl"
alias capturepage="bunx playwright screenshot"

alias winesteam='wine "$HOME/.wine/drive_c/Program Files (x86)/Steam/Steam.exe"'

binpath() {
	[ -n "$1" ] && realpath "$(command -v "$1")"
}

mkcd() {
	mkdir -p "$@" && cd "$1" || return
}

PS1='\n\u@\H\n\w\n$ '
