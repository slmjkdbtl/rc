# wengwengweng

# alias
alias o "open"
alias f "open ."
alias t "touch"
alias c "set_color"
alias j "just"
alias size "du -sh -- * | sort -h"
alias disk "df -h ."
alias v "nvim"
alias dl "aria2c"
alias ydl "youtube-dl --format mp4 -o '%(title)s.%(ext)s' -i --no-playlist"
alias ydll "youtube-dl --format mp4 -o '%(title)s.%(ext)s' -i --yes-playlist"
alias ydlm "youtube-dl -x --audio-format mp3 -o '%(title)s.%(ext)s' -i"
alias ase "/Applications/Aseprite.app/Contents/MacOS/aseprite --batch"
alias vps "ssh tga@bastardstickweed"
alias toix "curl -F 'f:1=<-' ix.io"
alias fzf "fzf --color=bg+:4,info:3,spinner:5,pointer:2"
alias dsclean "sudo fd -H -I -t f '.DS_Store' -x 'rm'; killall Finder"
alias dockerstart "open --background -a Docker"
alias dockerclean "docker rmi (docker images -qa -f 'dangling=true'); docker rm (docker ps -a -q)"
alias ip "ifconfig | grep 'inet.*broadcast' | awk '{print \$2}'"
alias ipv6 "ifconfig | grep 'inet6.*%en' | awk '{print \$2}' | sed 's/%en0//'"
alias extip "curl -4 -s -m 5 https://ifconfig.co"
alias extipv6 "curl -6 -s -m 5 https://ifconfig.co"
alias bf "brainfuck"
alias lg "lazygit"

type -q hub; and \
	alias git "hub"
type -q bat; and \
	alias cat "env PAGER='' bat --theme=TwoDark --style=plain"
type -q exa; and \
	alias ls exa

# nav
function ..    ; cd .. ; end
function ...   ; cd ../.. ; end
function ....  ; cd ../../.. ; end
function ..... ; cd ../../../.. ; end

# abbr
abbr gs git status
abbr ga git add .
abbr gc git commit -m
abbr gp git push
abbr gd git diff
abbr gb git branch
abbr gr git remote
abbr gch git checkout
abbr gcl git clone
abbr gpl git pull
abbr gbr git browse

# env
set -x BROWSER open
set -x TERM xterm-super
set -x PAGER less
set -x LANG en_US.UTF-8
set -x XDG_CONFIG_HOME $HOME/.config
set -x VIMRUNTIME $XDG_CONFIG_HOME/nvim

if type -q nvim
	set -x EDITOR nvim
else
	set -x EDITOR vim
end

# personal bin
if test -d $HOME/.bin
	set -x BIN $HOME/.bin
	set -x PATH $BIN $PATH
end

# fzf
if type -q fzf
	if type -q fd
		set -x FZF_DEFAULT_COMMAND "fd --type f"
	end
end

# jump
if type -q jump
	status --is-interactive; and . (jump shell --bind=z | psub)
end

# go
if test -d $HOME/.go
	set -x GOPATH $HOME/.go
end

if test -d $GOPATH/bin
	set -x PATH $GOPATH/bin $PATH
end

# cargo
if test -d $HOME/.cargo
	set -x PATH $HOME/.cargo/bin $PATH
end

# flutter
set -x FLUTTER_PATH $HOME/Documents/flutter

if test -d $FLUTTER_PATH
	set -x PATH $FLUTTER_PATH/bin $PATH
end

# fastlane
if test -d $HOME/.fastlane
	set -x PATH $HOME/.fastlane/bin $PATH
end

# carp
set -x CARP_DIR $HOME/.carp

# sccache
type -q sccache; and \
	set -x RUSTC_WRAPPER sccache

# wasmer
set -x WASMER_DIR "$HOME/.wasmer"

if test -d $WASM_DIR
	[ -s "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"
end

# homebrew
set -x HOMEBREW_NO_AUTO_UPDATE 1

# emcc
set -x LLVM_ROOT /usr/local/opt/emscripten/libexec/llvm/bin

# sbin
set -g fish_user_paths "/usr/local/sbin" $fish_user_paths

function fish_greeting
	echo ""
	echo " yo"
end

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

		set_color normal
		echo -n "> "

	end

	echo ""
	echo -n " "
	show_usr
	echo ""
	echo -n " "
	show_cwd
	echo -n " "
	show_git
	echo ""
	echo -n " "
	show_prompt

	functions -e show_cwd
	functions -e show_git
	functions -e show_prompt

end

function fish_title
	set -g fish_prompt_pwd_dir_length 0
	echo (prompt_pwd)
end

