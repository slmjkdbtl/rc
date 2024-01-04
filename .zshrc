. ~/.profile

autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%b '
setopt PROMPT_SUBST
PROMPT=$'\n%F{black}%n@%m%f\n%F{blue}%~%f %F{black}${vcs_info_msg_0_}%f\n$ '

bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word
