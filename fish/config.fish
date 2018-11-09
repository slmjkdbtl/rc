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
alias opengate "sudo spctl --master-disable"
alias ase "/Applications/Aseprite.app/Contents/MacOS/aseprite --batch"
alias vps "ssh t@wengwengweng"
alias website "open https://www.wengwengweng.me/"
alias dsclean "sudo find . -type f -name .DS_Store -delete; killall Finder"
alias sfxr "amulet $HOME/Things/tools/sfxr.lua"

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

if type -q nvim
	set -x EDITOR nvim
else
	set -x EDITOR vim
end

set -x PATH $HOME/.bin $PATH
set -x PATH $HOME/.local/bin $PATH

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

# carp
set -x CARP_DIR $HOME/.carp

# homebrew
set -x HOMEBREW_NO_AUTO_UPDATE 1

