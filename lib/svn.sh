ZSH_THEME_SVN_PROMPT_PREFIX="%{$fg_bold[blue]%}(%{$fg_no_bold[yellow]%}%B"
ZSH_THEME_SVN_PROMPT_SUFFIX="%b%{$fg_bold[blue]%})%{$reset_color%} "
ZSH_THEME_SVN_PROMPT_CLEAN=""
ZSH_THEME_SVN_PROMPT_DIRTY="%{$fg_bold[red]%}✗"

function svn()
{
  local cmd=$1
  shift

  case "${cmd}" in
    "status"|"stat"|"st")
      command svn ${cmd} --ignore-externals $@ | egrep -v '^\s*X' | perl -pe "s/^\\?.*$/\e[1;34m$&\e[m/; s/^!.*$/\e[1;31m$&\e[m/; s/^A.*$/\e[1;32m$&\e[m/; s/^M.*$/\e[1;33m$&\e[m/; s/^D.*$/\e[0;31m$&\e[m/"
    ;;

    "diff"|"di"|"d")
      command svn diff $@ | colordiff | less -RF
    ;;

    "update"|"up")
      local old_revision=$(command svn info $@ | awk '/^Revision:/ { print $2 }')
      local first_update=$((${old_revision} + 1))

      command svn ${cmd} $@

      local new_revision=$(command svn info $@ | awk '/^Revision:/ { print $2 }')

      if [ ${new_revision} -gt ${old_revision} ]; then
        svn log -v -rHEAD:${first_update} $@ | less -RF
      else
        echo "No changes."
      fi
    ;;

    "log"|"l")
      command svn log $@ | perl -pe "s/^-+$/\e[1;37m$&\e[m/; s/^r[0-9]+.+$/\e[0;33m$&\e[m/"
    ;;

    "blame"|"praise"|"annotate"|"ann")
      command svn ${cmd} $@ | perl -pe "s/^(\\s*[0-9]+\\s*)([^ ]+\\s*)(.*)$/\e[1;37m\$1\e[m\e[0;33m\$2\e[m\$3/" | less -RF
    ;;

    *)
      command svn ${cmd} $@
    ;;
  esac
}

compdef _subversion svn
