zmodload -a zsh/mapfile mapfile
zmodload -a zsh/pcre pcre
zmodload -a zsh/zle zle

HISTSIZE=10000
SAVEHIST=10000

export LANG='en_US.UTF-8'
export PAGER=less
export EDITOR=vim

if [[ -z "$ZSHFILES" ]]; then
  # TODO: find a more reliable, non-hacky way to get these
  ZSH_DOTDIR=${ZDOTDIR:-$HOME}
  ZSH_ETCDIR=$(dirname $(strings ${${0#-}:c:A} 2>/dev/null | grep -E '^/.+/zshenv'))

  [[ -d $ZSH_DOTDIR/.zsh/antigen ]] && ZSHFILES=$ZSH_DOTDIR/.zsh || ZSHFILES=$ZSH_ETCDIR/zshfiles

  if [ ! -e $ZSHFILES/antigen/antigen.zsh ]; then
    if [[ ! -d $ZSHFILES ]]; then
      echo "$ZSH_DOTDIR/.zsh or $ZSH_ETCDIR/zshfiles not found"
    else
      echo "$ZSHFILES/antigen not initialised"
    fi
    exit
  fi
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

setopt auto_cd auto_pushd chase_links pushd_ignore_dups pushd_to_home
setopt list_packed list_rows_first list_types
setopt equals extended_glob multibyte no_nomatch rematch_pcre
setopt correct no_correct_all
setopt extended_history hist_fcntl_lock hist_ignore_all_dups hist_ignore_space hist_reduce_blanks hist_verify inc_append_history no_share_history
setopt no_flow_control print_exit_value short_loops
setopt no_bg_nice no_check_jobs no_hup notify
setopt c_bases c_precedences function_argzero multios
setopt combining_chars

PROMPT='%{$fg[$NCOLOR]%}%B%n%b%{$reset_color%}:%{$fg[blue]%}%B%4(c:.../:)%3c%b%{$reset_color%} $(git_prompt_info)$(svn_prompt_info)%(!.#.$) '

unset HISTORY_SUBSTRING_SEARCH_ANYWHERE

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path $ZSH_DOTDIR/.zsh/cache

zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' group-name ''
zstyle ':completion:*' ignore-parents parent pwd
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle -d ':completion:*' users
zstyle ':completion:*' verbose yes
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*:default' list-packed true
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle -e ':completion:*:approximate:*' max-errors 'reply=( $(( ($#PREFIX+$#SUFFIX)/2 )) numeric )'
zstyle ':completion:*:expand:*' tag-order all-expansions
zstyle ':completion:*:scp:*' group-order files all-files users hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:scp:*' tag-order files users 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
zstyle ':completion:*:ssh:*' group-order hosts-domain hosts-host users hosts-ipaddr
zstyle ':completion:*:ssh:*' tag-order users 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters
zstyle ':completion:*:*:(mv|cp|scp|rm|diff|pkill):*' ignore-line other
zstyle ':completion:*:*:vim:*:*files' ignored-patterns '*?.class' '*?.ctxt' '*?.dvi' '*?.aux' '*?.log' '*?.ps' '*?.pdf' '*?.jpg' '*?.png'

[[ -e $ZSHFILES/aliases.sh ]] && source $ZSHFILES/aliases.sh
command ls $ZSHFILES/lib/*.sh >/dev/null 2>&1 && source $ZSHFILES/lib/*.sh

[[ -e $ZSH_ETCDIR/zshrc.local ]] && source $ZSH_ETCDIR/zshrc.local
[[ -e $ZSH_DOTDIR/.zshrc.local ]] && source $ZSH_DOTDIR/.zshrc.local
command ls $ZSHFILES/local/*.sh >/dev/null 2>&1 && source $ZSHFILES/local/*.sh
[[ $ZSHFILES != $ZSH_DOTDIR/.zsh ]] && command ls $ZSH_DOTDIR/.zsh/local/*.sh >/dev/null 2>&1 && source $ZSH_DOTDIR/.zsh/local/*.sh

# vim: set ft=zsh ts=2 sts=0 sw=2 et
