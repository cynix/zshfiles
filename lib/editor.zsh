if [ "$TERM" = 'dumb' ]; then
	return 1
fi

setopt combining_chars no_flow_control

zmodload zsh/terminfo
typeset -gA key_info
key_info=(
	'Ctrl'         '\C-'
	'CtrlLeft'     '\e[1;5D \e[5D \e\e[D \eOd \eO5D'
	'CtrlRight'    '\e[1;5C \e[5C \e\e[C \eOc \eO5C'
	'Escape'       '\e'
	'Meta'         '\M-'
	'Backspace'    "^?"
	'Delete'       "${terminfo[kdch1]}"
	'F1'           "${terminfo[kf1]}"
	'F2'           "${terminfo[kf2]}"
	'F3'           "${terminfo[kf3]}"
	'F4'           "${terminfo[kf4]}"
	'F5'           "${terminfo[kf5]}"
	'F6'           "${terminfo[kf6]}"
	'F7'           "${terminfo[kf7]}"
	'F8'           "${terminfo[kf8]}"
	'F9'           "${terminfo[kf9]}"
	'F10'          "${terminfo[kf10]}"
	'F11'          "${terminfo[kf11]}"
	'F12'          "${terminfo[kf12]}"
	'Insert'       "${terminfo[kich1]}"
	'Home'         "${terminfo[khome]}"
	'PageUp'       "${terminfo[kpp]}"
	'End'          "${terminfo[kend]}"
	'PageDown'     "${terminfo[knp]}"
	'Up'           "${terminfo[kcuu1]}"
	'Left'         "${terminfo[kcub1]}"
	'Down'         "${terminfo[kcud1]}"
	'Right'        "${terminfo[kcuf1]}"
	'BackTab'      "${terminfo[kcbt]}"
)

for key in "${(k)key_info[@]}"; do
	if [ -z "${key_info[$key]}" ]; then
		key_info[$key]='�'
	fi
done

function zle-line-init {
	if (( $+terminfo[smkx] )); then
		echoti smkx
	fi
}
zle -N zle-line-init

function zle-line-finish {
	if (( $+terminfo[rmkx] )); then
		echoti rmkx
	fi
}
zle -N zle-line-finish

function expand-or-complete-with-indicator {
	# Toggle line wrap before/after printing indicator
	[[ -n "${terminfo[rmam]}" && -n "${terminfo[smam]}" ]] && echoti rmam
	print -Pn "%{%F{red}...%f%}"
	[[ -n "${terminfo[rmam]}" && -n "${terminfo[smam]}" ]] && echoti smam

	zle expand-or-complete
	zle redisplay
}
zle -N expand-or-complete-with-indicator

autoload -Uz edit-command-line
zle -N edit-command-line

bindkey -M vicmd "v" edit-command-line

bindkey -M vicmd "u" undo
bindkey -M vicmd "${key_info[Ctrl]}R" redo

bindkey -M viins "${key_info[Home]}" beginning-of-line
bindkey -M viins "${key_info[End]}" end-of-line

bindkey -M viins "${key_info[Insert]}" overwrite-mode
bindkey -M viins "${key_info[Delete]}" delete-char
bindkey -M viins "${key_info[Backspace]}" backward-delete-char

for i in vicmd viins; do
	bindkey -M $i "${key_info[Up]}" history-substring-search-up
	bindkey -M $i "${key_info[Down]}" history-substring-search-down
done

bindkey -M viins "${key_info[Left]}" backward-char
bindkey -M viins "${key_info[Right]}" forward-char

for i in "${(s: :)key_info[CtrlLeft]}"
	bindkey -M viins "$i" backward-word
for i in "${(s: :)key_info[CtrlRight]}"
	bindkey -M viins "$i" forward-word

bindkey -M viins ' ' magic-space
bindkey -M viins "${key_info[Ctrl]}Q" push-line-or-edit
bindkey -M viins "${key_info[Ctrl]}I" expand-or-complete-with-indicator
bindkey -M viins "${key_info[BackTab]}" reverse-menu-complete

bindkey -v
unset i
