# wengwengweng

# misc
set -g fish_prompt_pwd_dir_length 0
set -g fish_greeting ""

# alias
alias o "open"
alias t "touch"
alias c "set_color"
alias size "du -sh"
alias make "make -s"
type -q nvim; and alias v "nvim"
type -q hub; and alias git "hub"

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

# go
if test -d $HOME/.go
	set -x GOPATH $HOME/.go
	set -x PATH $GOPATH/bin $PATH
end

# cargo
if test -d $HOME/.cargo
	set -x PATH $HOME/.cargo/bin $PATH
end

# term
set -x TERM xterm-256color

# editor
if type -q nvim
	set -x EDITOR nvim
else
	set -x EDITOR vim
end

# sbin
set -g fish_user_paths "/usr/local/sbin" $fish_user_paths

