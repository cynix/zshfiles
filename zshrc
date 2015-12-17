setopt auto_cd
setopt short_loops
setopt no_bg_nice no_check_jobs no_hup notify
setopt c_bases c_precedences function_argzero multios

zmodload -i zsh/zle
zmodload -i zsh/zutil
zmodload -ab zsh/mapfile mapfile
zmodload -ab zsh/pcre pcre_compile pcre_study pcre_match

export LANG='en_US.UTF-8'
export PAGER='less'
(( $+commands[vim] )) && export EDITOR='vim' || export EDITOR='vi'

typeset -gU cdpath fpath manpath path

export ZSHFILES="${${(%):-%N}:A:h}"
export ZSH_DOTDIR="${ZDOTDIR:-$HOME}"
export ZSH_ETCDIR="${${(%):-%N}:h}"
export ZPLUG_HOME="${ZPLUG_HOME:-$HOME/.zplug}"

if [[ ! -e $ZPLUG_HOME/zplug ]]; then
	if [[ ! -e $ZSHFILES/vendor/zplug/zplug && -d $ZSHFILES/.git ]] && (( $+commands[git] )); then
		pushd "$ZSHFILES" > /dev/null
		git submodule update --init --recursive
		popd > /dev/null
	fi

	source "$ZSHFILES/vendor/zplug/zplug"
	zplug update --self
fi

source "$ZPLUG_HOME/zplug"

zplug 'b4b4r07/zplug'

zplug 'b4b4r07/enhancd', of:enhancd.sh, if:"which fzf || which pick || which gof"
zplug 'rimraf/k', of:k.sh
zplug 'zsh-users/zsh-completions'
zplug 'zsh-users/zsh-syntax-highlighting', nice:17
zplug 'cynix/zsh-history-substring-search', nice:18

LP_ENABLE_BATT=0
LP_ENABLE_PROXY=0
LP_ENABLE_TEMP=0
LP_ENABLE_VCS_ROOT=1
zplug 'nojhan/liquidprompt', nice:19

zplug "$ZSHFILES/lib", from:local
[[ -d $ZSHFILES/local ]] && zplug "$ZSHFILES/local", from:local
[[ $ZSHFILES != $ZSH_DOTDIR/.zsh && -d $ZSH_DOTDIR/.zsh/local ]] && zplug "$ZSH_DOTDIR/.zsh/local", from:local

zplug check || zplug install
[[ -z $ZPLUG_NO_AUTO_LOAD ]] && zplug load

[[ $ZSH_ETCDIR != $ZSH_DOTDIR && -e $ZSH_ETCDIR/zshrc.local ]] && source "$ZSH_ETCDIR/zshrc.local"
[[ -e $ZSH_DOTDIR/.zshrc.local ]] && source "$ZSH_DOTDIR/.zshrc.local"

typeset -f cd::cd >/dev/null && compdef _cd cd::cd
