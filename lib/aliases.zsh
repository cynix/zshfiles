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
alias less='less -R'
alias v='vim'
alias tm='tmux attach || tmux new'
alias ic='iocage console'

function pg {
	pgrep ${(@)argv:#-l} | xargs $([[ $OSTYPE =~ linux* ]] && echo '-r') -n1 ps -o pid= -o user= -o command= -p
}

function jc {
	jexec $1 /usr/bin/login -f root
}

function ja {
	local i
	for i in $(jls name); do
		echo '=================================================='
		echo ">>> Executing '$@' in '$i'"
		echo '--------------------------------------------------'
		jexec $i $@
	done
}

jpkg () {
	for i in $(jls name); do
		echo '=================================================='
		echo ">>> Executing 'pkg $@' in '$i'"
		echo '--------------------------------------------------'
		pkg -j $i "$@"
	done
}
