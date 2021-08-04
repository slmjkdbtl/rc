set -x EDITOR nvim
set -x BROWSER open
set -x PAGER less
set -x PATH /opt/homebrew/bin $PATH
set -x PATH $HOME/.local/bin $PATH
set -x PATH /opt/homebrew/sbin $PATH
set -x PATH /opt/homebrew/opt/llvm/bin $PATH
set -x HOMEBREW_NO_AUTO_UPDATE 1
set fish_greeting

set -U fish_color_autosuggestion      brblack
set -U fish_color_cancel              -r
set -U fish_color_command             brgreen
set -U fish_color_comment             brmagenta
set -U fish_color_cwd                 green
set -U fish_color_cwd_root            red
set -U fish_color_end                 brmagenta
set -U fish_color_error               brred
set -U fish_color_escape              brcyan
set -U fish_color_history_current     --bold
set -U fish_color_host                normal
set -U fish_color_match               --background=brblue
set -U fish_color_normal              normal
set -U fish_color_operator            cyan
set -U fish_color_param               brblue
set -U fish_color_quote               yellow
set -U fish_color_redirection         bryellow
set -U fish_color_search_match        'bryellow' '--background=brblack'
set -U fish_color_selection           'white' '--bold' '--background=brblack'
set -U fish_color_status              red
set -U fish_color_user                brgreen
set -U fish_color_valid_path          --underline
set -U fish_pager_color_completion    normal
set -U fish_pager_color_description   yellow
set -U fish_pager_color_prefix        'white' '--bold' '--underline'
set -U fish_pager_color_progress      'brwhite' '--background=cyan'

alias .. "cd .."
alias ... "cd ../.."
alias .... "cd ../../.."
alias ..... "cd ../../../.."
alias e "$EDITOR"
alias o "open"
alias f "open ."
alias lsize="du -chs * .* | sort -h"
alias disk "df -h ."
alias sudo "sudo -E"
alias ydl "youtube-dl --format mp4 -o '%(title)s.%(ext)s' -i --no-playlist"
alias ydll "youtube-dl --format mp4 -o '%(title)s.%(ext)s' -i --yes-playlist"
alias ydlm "youtube-dl -x --audio-format mp3 -o '%(title)s.%(ext)s' -i --no-playlist"
alias ydlml "youtube-dl -x --audio-format mp3 -o '%(title)s.%(ext)s' -i --yes-playlist"
alias ase "/Applications/Aseprite.app/Contents/MacOS/aseprite --batch"
alias toix "curl -F 'f:1=<-' ix.io"
alias ip "ifconfig | grep 'inet.*broadcast' | awk '{print \$2}'"
alias extip "curl ifconfig.co"
alias playraw "ffplay -ar 8000 -ac 1 -f u8 -nodisp -"
alias weather "curl wttr.in"
alias dsclean "find . -name '.DS_Store' -print -delete"
alias dnsclear "sudo killall -HUP mDNSResponder"

abbr gs "git status"
abbr ga "git add -A"
abbr gc "git commit -m"
abbr gp "git push"
abbr gb "git branch"
abbr gr "git remote"
abbr gch "git checkout"
abbr gcl "git clone"
abbr gpl "git pull"
abbr grv "gh repo view --web"

type -q jump && status --is-interactive; and source (jump shell fish --bind=z | psub)

function fish_prompt

	function show_usr
		set_color white --dim
		echo -n (whoami)
		echo -n "@"
		echo -n (hostname)
		set_color normal
	end

	function show_cwd
		set_color -o green
		set -g fish_prompt_pwd_dir_length 0
		echo -n (prompt_pwd)
		set_color normal
	end

	function show_git
		command git rev-parse --is-inside-work-tree >/dev/null 2>&1; or return 1
		set_color -d $fish_color_git
		echo -n (__fish_git_prompt | string trim | string replace '(' '' | string replace ')' '')
		git diff-index --quiet HEAD -- >/dev/null 2>&1; or echo -n "*"
		set_color normal
	end

	function show_prompt
		set_color yellow
		echo -n "% "
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
