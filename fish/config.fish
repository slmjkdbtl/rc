# wengwengweng

# alias
alias git "hub"
alias o "open"
alias t "touch"
alias c "set_color"
alias work "genact"
alias cask "brew cask"
alias chmox "chmod +x"
alias size "du -sh"
alias make "make -s"
alias v "nvim"
alias iterm "/Applications/iTerm.app/Contents/MacOS/iTerm2"
alias aseprite "/Applications/Aseprite.app/Contents/MacOS/aseprite"
alias godot "/Applications/Godot.app/Contents/MacOS/Godot"

# nav
function ..    ; cd .. ; end
function ...   ; cd ../.. ; end
function ....  ; cd ../../.. ; end
function ..... ; cd ../../../.. ; end

# abbr
abbr gs git status
abbr ga git add .
abbr gc git commit -m
abbr gd git diff

# go
set -x GOPATH $HOME/.go
set -x PATH $GOPATH/bin $PATH

# sbin
set -g fish_user_paths "/usr/local/sbin" $fish_user_paths

# cargo
set -x PATH $HOME/.cargo/bin $PATH
set -x TERM xterm-256color

# editor
set -x EDITOR nvim

# start
echo ""

