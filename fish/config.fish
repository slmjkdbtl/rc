# wengwengweng

# alias
alias o "open"
alias t "touch"
alias c "set_color"
alias size "du -sh"
alias make "make -s"
type -q nvim; and alias vim "nvim"
type -q neomutt; and alias mutt "neomutt"
type -q hub; and alias git "hub"
type -q bat; and alias bat "env PAGER='' bat --theme=TwoDark --style=plain"
type -q bat; and alias cat bat
type -q exa; and alias ls exa

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
type -q lazygit; and abbr lg lazygit

# env
set -x BROWSER open
set -x TERM xterm-super
set -x PAGER less

if type -q nvim
	set -x EDITOR nvim
else
	set -x EDITOR vim
end

# plugins
set -g fplug_path $HOME/.config/fish/plugins
fplug load "fisherman/z"
fplug load "laughedelic/pisces"

# fzf
if type -q fzf
	if type -q fd
		set -x FZF_DEFAULT_COMMAND "fd --type f"
	end
end

# go
if test -d $HOME/.go

	set -x GOPATH $HOME/.go
	set -x PATH $GOPATH/bin $PATH

end

# cargo
if test -d $HOME/.cargo
	set -x PATH $HOME/.cargo/bin $PATH
end

# brew
set -x HOMEBREW_NO_AUTO_UPDATE 1

# openssl
if test -d /usr/local/opt/openssl

	set -g fish_user_paths "/usr/local/opt/openssl/bin" $fish_user_path
	set -gx LDFLAGS "-L/usr/local/opt/openssl/lib"
	set -gx CPPFLAGS "-I/usr/local/opt/openssl/include"
	set -gx PKG_CONFIG_PATH "/usr/local/opt/openssl/lib/pkgconfig"

end

# sbin
set -g fish_user_paths "/usr/local/sbin" $fish_user_paths

