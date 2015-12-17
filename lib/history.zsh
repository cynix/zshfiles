if [ -z "$HISTFILE" ]; then
	export HISTFILE="$HOME/.zsh_history"
fi

HISTSIZE=10000
SAVEHIST=10000

setopt extended_history hist_fcntl_lock hist_ignore_all_dups hist_ignore_space hist_reduce_blanks hist_verify inc_append_history no_share_history
