autoload -U colors && colors
export LSCOLORS="Gxfxcxdxbxegedabagacad"

if [[ "$(uname -s)" == "NetBSD" ]]; then
	gls --color -d . &>/dev/null 2>&1 && alias ls='gls --color=auto'
elif [[ "$(uname -s)" == "OpenBSD" ]]; then
	gls --color -d . &>/dev/null 2>&1 && alias ls='gls --color=auto'
	colorls -G -d . &>/dev/null 2>&1 && alias ls='colorls -G'
else
	ls --color -d . &>/dev/null 2>&1 && alias ls='ls --color=auto' || alias ls='ls -G'
fi

alias x='exit'
alias l='ls -A'
alias ll='ls -la'
alias v='vim'
alias tm='tmux attach || tmux new'
