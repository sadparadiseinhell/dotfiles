#
# ~/.bashrc
#

# Aliases
if [ -f ~/.bash_aliases ]; then
. ~/.bash_aliases
fi

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

git_branch() {
     GIT=$(git branch 2> /dev/null | grep "^*" | colrm 1 2)
     if [[ -n $GIT ]]; then
     	echo -e " \033[1;37m[\033[1;1;32m$GIT\033[1;37m]\033[0m"
     fi
}

PS1="\W\$(git_branch) $ "

# Delete key
tput smkx
