# wengwengweng

# alias
alias o "open"
alias f "open ."
alias t "touch"
alias c "set_color"
alias j "just"
alias size "du -h -d 1 . | sort -h"
alias disk "df -h ."
alias ncdu "ncdu --color=dark"
alias v "nvim"
alias yg "you-get"
alias ase "/Applications/Aseprite.app/Contents/MacOS/aseprite --batch"
alias vps "ssh t@wengwengweng"
alias dsclean "sudo fd -H -I -t f '.DS_Store' -x 'rm'; killall Finder"
alias toix "curl -F 'f:1=<-' ix.io"
alias fzf "fzf --color=bg+:4,info:3,spinner:5,pointer:2"

type -q neomutt; and \
	alias mutt "neomutt"
type -q hub; and \
	alias git "hub"
type -q bat; and \
	alias cat "env PAGER='' bat --theme=TwoDark --style=plain"
type -q exa; and \
	alias ls exa
type -q lazygit; and \
	alias lg lazygit

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
abbr gb git browse

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

function tobin -d "move executable to bin" -a "file"
	switch "$file"
		case ""
			c red; echo "no file provided"; c normal
			return 1
		case "*"
			if not test -e "$file"
				c red; echo "file not exist"; c normal
				return 1
			end
			chmod +x $file
			install -v $file $BIN
	end
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
if test -d $HOME/.flutter
	set -x PATH $HOME/.flutter/bin $PATH
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

# homebrew
set -x HOMEBREW_NO_AUTO_UPDATE 1

# emcc
set -x LLVM_ROOT /usr/local/opt/emscripten/libexec/llvm/bin

# sbin
set -g fish_user_paths "/usr/local/sbin" $fish_user_paths

# ruby
if test -d /usr/local/opt/ruby/bin
	set -g fish_user_paths "/usr/local/opt/ruby/bin" $fish_user_paths
end

