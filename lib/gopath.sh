export GOPATH=$HOME/go
path+=(${GOPATH//://bin:}/bin)
typeset -U path

# vim: set ft=zsh ts=2 sts=0 sw=2 et
