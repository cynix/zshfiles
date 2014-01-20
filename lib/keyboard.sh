bindkey -v

bindkey '\e[1~' beginning-of-line
bindkey '\e[2~' overwrite-mode
bindkey '\e[3~' delete-char
bindkey '\e[4~' end-of-line
bindkey '\e[A'  history-substring-search-up
bindkey '\e[B'  history-substring-search-down
bindkey '\e[C'  forward-char
bindkey '\e[D'  backward-char
bindkey '^q'    push-line-or-edit
