#
# ~/.bashrc
#

# Aliases
if [ -f ~/.bash_aliases ]; then
. ~/.bash_aliases
fi

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='\W $ '

# Delete key
tput smkx
