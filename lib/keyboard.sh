bindkey -v

bindkey "${terminfo[khome]}" beginning-of-line
bindkey "${terminfo[kdch1]}" delete-char
bindkey "${terminfo[kend]}"  end-of-line
bindkey "${terminfo[kcuu1]}" history-substring-search-up
bindkey "${terminfo[kcud1]}" history-substring-search-down
bindkey "${terminfo[kcuf1]}" forward-char
bindkey "${terminfo[kcub1]}" backward-char
bindkey '^q'                 push-line-or-edit
