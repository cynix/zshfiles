setopt list_packed list_rows_first list_types
setopt equals extended_glob multibyte no_nomatch rematch_pcre
setopt correct no_correct_all

zmodload -i zsh/complist

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
zstyle ':completion:*:(mv|cp|scp|rm|diff|pkill):*' ignore-line other
zstyle ':completion:*:vim:*:*files' ignored-patterns '*?.class' '*?.ctxt' '*?.dvi' '*?.aux' '*?.log' '*?.ps' '*?.pdf' '*?.jpg' '*?.png'
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"

# Don't complete uninteresting users
zstyle ':completion:*:*:*:users' ignored-patterns \
	adm amanda apache at avahi avahi-autoipd beaglidx bin cacti canna \
	clamav daemon dbus distcache dnsmasq dovecot fax ftp games gdm \
	gkrellmd gopher hacluster haldaemon halt hsqldb ident junkbust kdm \
	ldap lp mail mailman mailnull man messagebus  mldonkey mysql nagios \
	named netdump news nfsnobody nobody nscd ntp nut nx obsrun openvpn \
	operator pcap polkitd postfix postgres privoxy pulse pvm quagga radvd \
	rpc rpcuser rpm rtkit scard shutdown squid sshd statd svn sync tftp \
	usbmux uucp vcsa wwwrun xfs '_*'

zstyle '*' single-ignored show
