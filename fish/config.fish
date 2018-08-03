# wengwengweng

# misc
set fish_greeting ""

# alias
alias git "hub"
alias o "open"
alias t "touch"
alias c "set_color"
alias size "du -sh"
alias make "make -s"
alias v "nvim"

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

# go
set -x GOPATH $HOME/.go
set -x PATH $GOPATH/bin $PATH

# cargo
set -x PATH $HOME/.cargo/bin $PATH

# term
set -x TERM xterm-256color

# editor
set -x EDITOR nvim

# start
echo ""

