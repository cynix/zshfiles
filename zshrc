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

if [[ ! -e $ZSHFILES/vendor/zplug/init.zsh && -d $ZSHFILES/.git ]] && (( $+commands[git] )); then
	pushd "$ZSHFILES" > /dev/null
	git submodule update --init --recursive
	popd > /dev/null
fi

source "$ZSHFILES/vendor/zplug/init.zsh"

zplug "$ZSHFILES/vendor/enhancd", from:local, use:init.sh, if:"which fzy || which fzf"
zplug "$ZSHFILES/vendor/bundler-exec", from:local, use:bundler-exec.sh, if:'which bundle'
zplug "$ZSHFILES/vendor/zsh-completions", from:local

HISTORY_SUBSTRING_SEARCH_ANYWHERE=0
zplug "$ZSHFILES/vendor/zsh-history-substring-search", from:local

zplug "$ZSHFILES/vendor/zsh-syntax-highlighting", from:local, defer:3

LP_ENABLE_BATT=0
LP_ENABLE_PROXY=0
LP_ENABLE_TEMP=0
LP_ENABLE_VCS_ROOT=1
[[ $OSTYPE == freebsd* ]] && (( $(sysctl -in security.jail.jailed) )) && LP_HOSTNAME_ALWAYS=1
zplug "$ZSHFILES/vendor/liquidprompt", from:local, defer:2

zplug "$ZSHFILES/lib", from:local
[[ -d $ZSHFILES/local ]] && zplug "$ZSHFILES/local", from:local
[[ $ZSHFILES != $ZSH_DOTDIR/.zsh && -d $ZSH_DOTDIR/.zsh/local ]] && zplug "$ZSH_DOTDIR/.zsh/local", from:local

zplug check || zplug install
[[ -z $ZPLUG_NO_AUTO_LOAD ]] && zplug load

[[ $ZSH_ETCDIR != $ZSH_DOTDIR && -e $ZSH_ETCDIR/zshrc.local ]] && source "$ZSH_ETCDIR/zshrc.local"
[[ -e $ZSH_DOTDIR/.zshrc.local ]] && source "$ZSH_DOTDIR/.zshrc.local"

typeset -f cd::cd >/dev/null && compdef _cd cd::cd
