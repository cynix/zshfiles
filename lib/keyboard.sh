bindkey -v

autoload termcap

bindkey '\e[1~' beginning-of-line
bindkey '\e[2~' overwrite-mode
bindkey '\e[3~' delete-char
bindkey '\e[4~' end-of-line
bindkey "${termcap[ku]}" history-substring-search-up
bindkey "${termcap[kd]}" history-substring-search-down
bindkey "${termcap[kr]}" forward-char
bindkey "${termcap[kl]}" backward-char
bindkey '^q'    push-line-or-edit
