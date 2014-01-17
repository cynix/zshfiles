zmodload -a zsh/mapfile mapfile
zmodload -a zsh/pcre pcre
zmodload -a zsh/zle zle

bindkey -v

HISTSIZE=10000
SAVEHIST=10000

export LANG='en_US.UTF-8'
export PAGER=less
export EDITOR=vim

setopt auto_cd auto_pushd chase_links pushd_ignore_dups pushd_to_home
setopt list_packed list_rows_first list_types
setopt equals extended_glob multibyte no_nomatch rematch_pcre
setopt correct no_correct_all
setopt extended_history hist_fcntl_lock hist_ignore_all_dups hist_ignore_space hist_reduce_blanks hist_verify inc_append_history no_share_history
setopt no_flow_control print_exit_value short_loops
setopt no_bg_nice no_check_jobs no_hup notify
setopt c_bases c_precedences function_argzero multios
setopt combining_chars

autoload -Uz compinit && compinit

zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' group-name ''
zstyle ':completion:*' single-ignored show

zstyle ':completion:*:cd:*' ignore-parents parent pwd
zstyle ':completion:*:(mv|cp|scp|rm|diff|pkill):*' ignore-line other

# TODO: find a more reliable, non-hacky way to get these
ZSH_DOTDIR=${ZDOTDIR:-$HOME}
ZSH_ETCDIR=$(dirname $(strings $SHELL | grep -E '^/.+/zshenv' || strings $0 | grep -E '^/.+/zshenv'))

[[ -d $ZSH_DOTDIR/.zsh/antigen ]] && ZSHFILES=$ZSH_DOTDIR/.zsh || ZSHFILES=$ZSH_ETCDIR/zshfiles

if [ ! -e $ZSHFILES/antigen/antigen.zsh ]; then
  if [[ ! -d $ZSHFILES ]]; then
    echo "~/.zsh or $GLOBAL_RC_DIR/zshfiles not found"
  else
    echo "$ZSHFILES/antigen not initialised"
  fi
  exit
fi

source $ZSHFILES/antigen/antigen.zsh

COMPLETION_WAITING_DOTS=true

antigen use oh-my-zsh

antigen bundles <<ENDBUNDLES
  brew
  bundler
  colored-man
  compleat
  cynix/zsh-history-substring-search
  cynix/zsh-svn
  dircycle
  git
  git-extras
  pip
  zsh-users/zsh-syntax-highlighting
ENDBUNDLES

antigen theme clean

antigen apply

PROMPT='%{$fg[$NCOLOR]%}%B%n%b%{$reset_color%}:%{$fg[blue]%}%B%4(c:.../:)%3c%b%{$reset_color%} $(git_prompt_info)$(svn_prompt_info)%(!.#.$) '

bindkey "\e[A" history-substring-search-up
bindkey "\e[B" history-substring-search-down
unset HISTORY_SUBSTRING_SEARCH_ANYWHERE

[[ -e $ZSHFILES/aliases.sh ]] && source $ZSHFILES/aliases.sh
command ls $ZSHFILES/lib/*.sh >/dev/null 2>&1 && source $ZSHFILES/lib/*.sh

[[ -e $ZSH_ETCDIR/zshrc.local ]] && source $ZSH_ETCDIR/zshrc.local
[[ -e $ZSH_DOTDIR/.zshrc.local ]] && source $ZSH_DOTDIR/.zshrc.local
command ls $ZSHFILES/local/*.sh >/dev/null 2>&1 && source $ZSHFILES/local/*.sh
[[ $ZSHFILES != $ZSH_DOTDIR/.zsh ]] && command ls $ZSH_DOTDIR/.zsh/local/*.sh >/dev/null 2>&1 && source $ZSH_DOTDIR/.zsh/local/*.sh

# vim: set ft=zsh ts=2 sts=0 sw=2 et
