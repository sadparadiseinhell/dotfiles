#
# ~/.bashrc
#

# Delete key
tput smkx

# Aliases
if [ -f ~/.bash_aliases ]; then
. ~/.bash_aliases
fi

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Colors
reset=$(tput sgr0)
red=$(tput setaf 1)
blue=$(tput setaf 4)
green=$(tput setaf 2)

# Prompt
PS1="\W $ "

# Complete command
complete -cf sudo
complete -c man which

# Auto 'cd'
shopt -s autocd

# Line wrap on window resize
shopt -s checkwinsize

# Colored man
man() {
    LESS_TERMCAP_md=$'\e[01;31m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;44;33m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;32m' \
    command man "$@"
}
