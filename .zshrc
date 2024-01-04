. ~/.profile

autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%b '
setopt PROMPT_SUBST
PROMPT=$'\n%F{black}%n@%M%f\n%B%F{blue}%~%f%b %F{black}${vcs_info_msg_0_}%f\n$ '

bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word

WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

use() { test -e $1 && source $1 }
use /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
use /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
use /opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh
use /opt/homebrew/share/zsh-autopair/autopair.zsh
unset -f use
