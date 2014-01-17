HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zhistory

export PAGER=less
export EDITOR=vim

unsetopt correct_all
setopt correct
setopt complete_aliases
setopt inc_append_history extended_history hist_ignore_space hist_ignore_all_dups no_share_history
setopt no_no_match

autoload -Uz compinit && compinit

zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' group-name ''

zstyle ':completion:*:cd:*' ignore-parents parent pwd
zstyle ':completion:*:(mv|cp|scp|rm|diff|pkill):*' ignore-line other

# TODO: find a more reliable, non-hacky way to get these
ZSH_DOTDIR=${ZDOTDIR:-$HOME}
ZSH_ETCDIR=$(dirname $(strings $SHELL | grep -E '^/.+/zshenv' | head))

[[ -d $ZSH_DOTDIR/.zsh ]] && ZSHFILES=$ZSH_DOTDIR/.zsh || ZSHFILES=$ZSH_ETCDIR/zshfiles

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

[[ -e $ZSH_DOTDIR/.zshrc.local ]] && source $ZSH_DOTDIR/.zshrc.local
command ls $ZSHFILES/local/*.sh >/dev/null 2>&1 && source $ZSHFILES/local/*.sh
[[ $ZSHFILES != $ZSH_DOTDIR/.zsh ]] && command ls $ZSH_DOTDIR/.zsh/local/*.sh >/dev/null 2>&1 && source $ZSH_DOTDIR/.zsh/local/*.sh

# vim: set ft=zsh ts=2 sts=0 sw=2 et
