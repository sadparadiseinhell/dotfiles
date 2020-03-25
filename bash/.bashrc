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

PS1="\W \e[32m$\e[0m "
