set -x EDITOR vim
set -x BROWSER open
set -x PAGER less
set -x GOPATH $HOME/.go
set -x JAVA_HOME /Library/Java/JavaVirtualMachines/openjdk.jdk/Contents/Home
set -x BUN_INSTALL "$HOME/.bun"
set -x PATH $HOME/.local/bin $PATH
set -x PATH /opt/homebrew/bin $PATH
set -x PATH /opt/homebrew/sbin $PATH
set -x PATH /opt/homebrew/opt/llvm/bin $PATH
set -x PATH $HOME/.cargo/bin $PATH
set -x PATH $GOPATH/bin $PATH
set -x PATH $BUN_INSTALL/bin $PATH
set fish_greeting

set -U fish_color_autosuggestion      black
set -U fish_color_cancel
set -U fish_color_command             green --bold
set -U fish_color_comment             magenta
set -U fish_color_cwd
set -U fish_color_cwd_root
set -U fish_color_end
set -U fish_color_error               red -- bold
set -U fish_color_escape
set -U fish_color_history_current
set -U fish_color_host
set -U fish_color_match
set -U fish_color_normal
set -U fish_color_operator            cyan
set -U fish_color_param
set -U fish_color_quote
set -U fish_color_redirection
set -U fish_color_search_match        --bold --background=blue
set -U fish_color_selection
set -U fish_color_status
set -U fish_color_user
set -U fish_color_valid_path
set -U fish_pager_color_completion
set -U fish_pager_color_description
set -U fish_pager_color_prefix
set -U fish_pager_color_progress

alias .. "cd .."
alias ... "cd ../.."
alias .... "cd ../../.."
alias ..... "cd ../../../.."
alias e "$EDITOR"
alias o "open"
alias f "open ."
alias lsize "du -chs * .* | sort -h"
alias disk "df -h ."
alias sudo "sudo -E"
alias ydl "yt-dlp --format mp4 -o '%(title)s.%(ext)s' -i --no-playlist"
alias ydll "yt-dlp --format mp4 -o '%(title)s.%(ext)s' -i --yes-playlist"
alias ydlm "yt-dlp -x --audio-format mp3 -o '%(title)s.%(ext)s' -i --no-playlist"
alias ydlmc "yt-dlp -x --audio-format mp3 --split-chapters -o '%(chapter)s.%(ext)s' -i --no-playlist"
alias ydlml "yt-dlp -x --audio-format mp3 -o '%(title)s.%(ext)s' -i --yes-playlist"
alias ase "/Applications/Aseprite.app/Contents/MacOS/aseprite --batch"
alias toix "curl -F 'f:1=<-' ix.io"
alias localip "ipconfig getifaddr en0"
alias extip "curl ifconfig.co"
alias playraw "ffplay -ar 8000 -ac 1 -f u8 -nodisp -"
alias weather "curl 'wttr.in?m'"
alias dnsclear "sudo killall -HUP mDNSResponder"
alias dsclean "find . -name '.DS_Store' -print -delete"
alias nogatekeep "sudo spctl --master-disable"
alias dl "aria2c -x 8 -d $HOME/Downloads"

abbr gs "git status"
abbr ga "git add -A"
abbr gc "git commit -m"
abbr gp "git push"
abbr gb "git branch"
abbr gr "git remote"
abbr gd "git diff"
abbr gsw "git switch"
abbr gcl "git clone"
abbr gpl "git pull"
abbr grv "gh repo view --web"

# jump
type -q jump && status --is-interactive; and source (jump shell fish --bind=z | psub)

# gcloud
if [ -f '/Users/tga/.local/share/gcloud/path.fish.inc' ]; . '/Users/tga/.local/share/gcloud/path.fish.inc'; end

function fish_prompt

	function show_usr
		set_color black
		echo -n (whoami)
		echo -n "@"
		echo -n (hostname)
		set_color normal
	end

	function show_cwd
		set_color -o cyan
		set -g fish_prompt_pwd_dir_length 0
		echo -n (prompt_pwd)
		set_color normal
	end

	function show_git
		command git rev-parse --is-inside-work-tree >/dev/null 2>&1; or return 1
		set_color black
		echo -n (git rev-parse --abbrev-ref HEAD 2> /dev/null)
		git diff-index --quiet HEAD -- > /dev/null 2>&1; or echo -n "*"
		set_color normal
	end

	function show_prompt
		set_color yellow
		echo -n "> "
	end

	echo ""
	show_usr
	echo ""
	show_cwd
	echo -n " "
	show_git
	echo ""
	show_prompt

	functions -e show_cwd
	functions -e show_git
	functions -e show_prompt

end

function fish_title
	set -g fish_prompt_pwd_dir_length 0
	echo (prompt_pwd)
end
