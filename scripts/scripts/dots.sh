#!/bin/bash

HOMEDIR="/home/ma/"
CONFIGDIR="/home/ma/.config/"
DOTFILESDIR="/home/ma/dotfiles/"

if [ -x "$(command -v tput)" ]; then
	bold="$(tput bold)"
	black="$(tput setaf 0)"
	red="$(tput setaf 1)"
	green="$(tput setaf 2)"
	yellow="$(tput setaf 3)"
	blue="$(tput setaf 4)"
	magenta="$(tput setaf 5)"
	cyan="$(tput setaf 6)"
	white="$(tput setaf 7)"
	grey="$(tput setaf 8)"
	reset="$(tput sgr0)"
fi

rbb="${reset}${bold}${blue}"
rbr="${reset}${bold}${red}"
rbg="${reset}${bold}${green}"
rby="${reset}${bold}${yellow}"

#while [ -n "$1" ]; do
#	case "$1" in
#		-h)
#			echo 'Try "--help"'
#			exit	;;
#		--help)
#			echo '--full          Copy all dotfiles'
#			exit	;;
#		*)
#			echo "$1 is not an option"
#			exit	;;
#	esac
#	shift
#done

clear

if [ "$(fortune &> /dev/null; echo $?)" -eq 0 ]; then
	echo -e "${bold}Before we start:${reset}\n${cyan}$(fortune)${reset}"
fi

echo -e "${bold}\n----------------------------------------------"
echo "|                                            |"
echo "|                  HELLO!                    |"
echo "|          This ${red}script${reset}${bold} will copy             |"
echo "|    dotfiles from the GitHub repository     |"
echo "|              to your system                |"
echo "|                                            |"
echo -e "----------------------------------------------\n${reset}"

read -p "$(echo -e "Copy ${rbb}bspwm${reset} (with ${rbr}sxhkd${reset} and ${rbg}polybar${reset}) config files? (y/${bold}N${reset}): ")" choice
	if [[ "$choice" = [Yy] ]]; then
		cp -r $HOME/repositories/dotfiles/.config/bspwm/ $HOME/.config/
		cp -r $HOME/repositories/dotfiles/.config/sxhkd/ $HOME/.config/
		cp -r $HOME/repositories/dotfiles/.config/polybar $HOME/.config/
		echo -e "\n${rby}DONE${reset}\n"
	else
		echo -e "\n${rbr}~${reset}\n"
	fi

	read -p "$(echo -e "Copy ${rbb}dwm${r}, ${rbr}dmenu${r}, ${rbg}slock${r}, ${rby}st${r}  config files? (y/${b}N${r}): ")" choice
	if [[ "$choice" = [Yy] ]]; then
		cp -r $HOME/repositories/dotfiles/build/ $HOME/ &> /dev/null
		echo -e "\n${rby}DONE${reset}\n" 
		if [ "$?" = 1 ]; then
			mkdir $HOME/build
			cp -r $HOME/repositories/dotfiles/build/ $HOME/
			echo -e "\n${rby}DONE${reset}\n" 
		fi
	else
		echo -e "\n${rbr}~${reset}\n"
	fi

	read -p "$(echo -e "Copy ${rbb}i3${reset} config files? (y/${bold}N${reset}): ")" choice
	if [[ "$choice" = [Yy] ]]; then
		cp -r $HOME/repositories/dotfiles/.config/i3 $HOME/.config/
		cp -r $HOME/repositories/dotfiles/.config/polybar $HOME/.config/
		echo -e "\n${rby}DONE${reset}\n"
	else
		echo -e "\n${rbr}~${reset}\n" 
	fi

read -p "$(echo -e "Copy ${rbb}mpd${reset} and ${rbr}ncmpcpp${reset} config files? (y/${bold}N${reset}): ")" choice
if [[ "$choice" = [Yy] ]]; then
	cp -r /home/ma/dotfiles1/.config/mpd ~/config/
	cp -r /home/ma/dotfiles1/.config/ncmpcpp ~/config/
	echo -e "\n${rby}DONE${reset}\n"
else
	echo -e "\n${rbr}~${reset}\n" 
fi

read -p "$(echo -e "Copy ${rbb}pywal${reset} config files? (y/${bold}N${reset}): ")" choice
if [[ "$choice" = [Yy] ]]; then
	cp -r /home/ma/dotfiles1/.config/wal ~/config/
	echo -e "\n${rby}DONE${reset}\n"
else
	echo -e "\n${rbr}~${reset}\n" 
fi

read -p "$(echo -e "Copy ${rbb}dunst${reset} config files? (y/${bold}N${reset}): ")" choice
if [[ "$choice" = [Yy] ]]; then
	cp -r /home/ma/dotfiles1/.config/dunst ~/config/
	echo -e "\n${rby}DONE${reset}\n"
else
	echo -e "\n${rbr}~${reset}\n"
fi

read -p "$(echo -e "Copy ${rbb}rofi${reset} config files? (y/${bold}N${reset}): ")" choice
if [[ "$choice" = [Yy] ]]; then
	cp -r /home/ma/dotfiles1/.config/rofi ~/config/
	echo -e "\n${rby}DONE${reset}\n"
else
	echo -e "\n${rbr}~${reset}\n"
fi

read -p "$(echo -e "Copy ${rbb}picom${reset} config files? (y/${bold}N${reset}): ")" choice
if [[ "$choice" = [Yy] ]]; then
	cp -r /home/ma/dotfiles1/.config/compton.conf ~/config/
	echo -e "\n${rby}DONE${reset}\n"
else
	echo -e "\n${rbr}~${reset}\n"
fi

read -p "$(echo -e "Copy ${rbb}other stuff${reset} config files? (y/${bold}N${reset}): ")" choice
if [[ "$choice" = [Yy] ]]; then
	cp -r /home/ma/dotfiles1/.bash_aliases ~/config/
	cp -r /home/ma/dotfiles1/.bashrc ~/config/
	cp -r /home/ma/dotfiles1/.xinitrc ~/config/
	cp -r /home/ma/dotfiles1/.Xresources ~/config/
	cp -r /home/ma/dotfiles1/.tmux.conf ~/config/
	echo -e "\n${rby}DONE${reset}\n"
else
	echo -e "\n${rbr}~${reset}\n"
fi

read -p "$(echo -e "Copy ${rbb}vim${reset} config files? (y/${bold}N${reset}): ")" choice
if [[ "$choice" = [Yy] ]]; then
	cp -r /home/ma/dotfiles1/.vim ~/config/
	cp -r /home/ma/dotfiles1/.vimrc ~/config/
	echo -e "\n${rby}DONE${reset}\n"
else
	echo -e "\n${rbr}~${reset}\n"
fi

read -p "$(echo -e "Copy ${rbb}scripts${reset} folder? (y/${bold}N${reset}): ")" choice
if [[ "$choice" = [Yy] ]]; then
	cp -r /home/ma/dotfiles1/scripts ~/config/
	echo -e "\n${rby}DONE${reset}\n"
else
	echo -e "\n${rbr}~${reset}\n"
fi
