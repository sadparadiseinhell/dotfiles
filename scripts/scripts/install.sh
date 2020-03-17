#!/bin/bash

PP=$(echo -e "xorg-server \nxorg-apps \nxorg-xinit \npython-pywal \nleafpad \nalsa-utils \npulseaudio \nlibnotify \nchromium \npicom \npcmanfm \nsxiv \ndunst \npython-dbus \nmpd \nncmpcpp \nranger \nttf-font-awesome \nfeh \nnetworkmanager \nmaim \nttf-hack \nadapta-gtk-theme \ngit \ntumbler \nffmpegthumbnailer \ntransmission-gtk \nmpv \nttf-dejavu \ntmux \nttf-roboto \nttf-droid \nmpc \nyoutube-dl \ncurl \npamixer \nfortune-mod \nlxappearance \npacman-contrib \nxarchiver \nunzip \nscrot \nman \nxclip \nxautolock \nstow \ntree \nw3m \nvim \nbc" | sort)

PA=$(echo -e "skb \nspotify \nsublime-text-dev \npaper-icon-theme-git \ntelegram-desktop-bin \nchromium-widevine \nttf-monaco \nclipmenu" | sort)


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

rbr="${reset}${bold}${red}"
rbg="${reset}${bold}${green}"
rby="${reset}${bold}${yellow}"
rbb="${reset}${bold}${blue}"
rbm="${reset}${bold}${magenta}"
rbc="${reset}${bold}${cyan}"
rbw="${reset}${bold}${white}"
rbgrey="${reset}${bold}${grey}"
b="${bold}"
r="${reset}"


folders () {
	read -p "$(echo -e "Create folders for: ${rbb}music${r}, ${rbr}movies${r}, ${rbg}screenshots${r}? (y/${bold}N${reset}): ")" choice
	if [[ "$choice" = [Yy] ]]; then
		mkdir $HOME/{music,movies,screenshots}
		echo -e "${rby}\nDONE${reset}\n"
	else
		echo -e "\n${rbr}~${reset}\n"
	fi
}

dotfiles () {
	read -p "$(echo -e "Download dotfiles from ${bold}${blue}GitHub${reset}? (y/${bold}N${reset}): ")" choice
	if [[ "$choice" = [Yy] ]]; then
		cd $HOME/
    	git clone https://github.com/sadparadiseinhell/dotfiles.git
    	git clone https://github.com/sadparadiseinhell/sadparadiseinhell.github.io.git
    	cd ..
    	echo -e "\n${rby}DONE${reset}\n"
	else
		echo -e "\n${rbr}~${reset}\n"
	fi
}

pcmnpackages () {
	read -p "$(echo -e "Install base packages (${bold}${yellow}pacman${reset})? (y/${bold}N${reset}): ")" choice
	if [[ "$choice" = [Yy] ]]; then
		read -p "$(echo -e "\nShow package list? (y/${bold}N${reset}): ")" choice
		if [[ "$choice" = [Yy] ]]; then
			echo -e "\n${bold}${green}$PP${reset}"
			read -p "$(echo -e "\nEdit package list? (y/${bold}N${reset}): ")" choice

			if [[ "$choice" = [Yy] ]]; then
				echo "$PP" > /tmp/packagelist.txt
				read -p "$(echo -e "${bold}\nEditor:${reset} ")" editor
				if [ -n "$editor" ]; then
					$editor /tmp/packagelist.txt
				else
					nano /tmp/packagelist.txt
				fi
				sudo pacman -S $(cat /tmp/packagelist.txt)
				rm /tmp/packagelist.txt &> /dev/null
			else
				sudo pacman -S $(echo "$PP")
				rm /tmp/packagelist.txt &> /dev/null		
			fi
			echo -e "${rby}DONE${reset}\n"
		else
			sudo pacman -S $(echo "$PP")
			rm /tmp/packagelist.txt &> /dev/null
			echo -e "\n${rby}DONE${reset}\n"
		fi
	else
		echo -e "\n${rbr}~${reset}\n"
	fi
}

aurpackages () {
	read -p "$(echo -e "Install packages (${rbb}AUR${reset})? (y/${bold}N${reset}): ")" choice
	if [[ "$choice" = [Yy] ]]; then
		read -p "$(echo -e "\nShow package list? (y/${bold}N${reset}): ")" choice
		if [[ "$choice" = [Yy] ]]; then
			echo -e "\n${bold}${green}$PA${reset}"
			read -p "$(echo -e "\nEdit package list? (y/${bold}N${reset}): ")" choice
			if [[ "$choice" = [Yy] ]]; then
				echo "$PA" > /tmp/packagelistaur.txt
				read -p "$(echo -e "${bold}\nEditor:${reset} ")" editor
				if [ -n "$editor" ]; then
					$editor /tmp/packagelistaur.txt
				else
					nano /tmp/packagelistaur.txt
				fi
				yay -S $(cat /tmp/packagelistaur.txt)
				rm /tmp/packagelistaur.txt &> /dev/null
			else
				yay -S $(echo "$PA")
				rm /tmp/packagelistaur.txt &> /dev/null		
			fi
			echo -e "\n${rby}DONE${reset}\n"
		else
			yay -S $(echo "$PA")
			rm /tmp/packagelistaur.txt &> /dev/null
			echo -e "\n${rby}DONE${reset}\n"
		fi
	else
		echo -e "\n${rbr}~${reset}\n"
	fi
}

dots () {

	if [ "$(fortune &> /dev/null; echo $?)" -eq 0 ]; then
		echo -e "${bold}Before we start:${reset}\n${cyan}$(fortune)${reset}"
	fi

	echo -e "${bold}\n----------------------------------------------"
	echo "|                                            |"
	echo "|                  HELLO!                    |"
	echo "|          This script will copy             |"
	echo "|    dotfiles from the GitHub repository     |"
	echo "|              to your system                |"
	echo "|                                            |"
	echo -e "----------------------------------------------\n${reset}"


	read -p "$(echo -e "Clone ${rbb}dotfiles${r} and ${rbr}startpage${r} from ${rbg}GitHub${r} repository? (y/${b}N${r}): ")" choice
	if [[ "$choice" = [Yy] ]]; then
		cd $HOME/
	    git clone https://github.com/sadparadiseinhell/dotfiles.git
	    git clone https://github.com/sadparadiseinhell/sadparadiseinhell.github.io.git
	    echo -e "\n${rby}REPOSITORIES SUCCESSFULLY CLONED${reset}\n"
	else
		echo -e "\n${rbr}~${reset}\n"
	fi

	echo -e "Make symlinks for ${rbb}all dotfiles${reset} or ${rbg}individually${r}?\n"

	OPTIONS="$(echo -e 'All \nIndividually \nSkip')"
	select opt in $OPTIONS; do
		if [[ "$opt" = "All" ]]; then
			mv $HOME/dotfiles/README.md $HOME/
			rm $HOME/.bashrc
			cd $HOME/dotfiles/
			stow *

			sudo chmod 777 /usr/local/bin
			sudo chmod 777 /usr/local/man
			sudo chmod 777 /usr/local/man1

			cd $HOME/build/dwm/
			make &> /dev/null
			make install

			cd $HOME/build/st
			make &> /dev/null
			make install

			cd $HOME/build/dmenu
			make &> /dev/null
			make install

			cd $HOME/build/slock/
			make &> /dev/null
			sudo make install

			cd $HOME

			mv $HOME/README.md $HOME/dotfiles/

			sudo cp $HOME/dotfiles/configs/.config/wal/colors-wal-dwm.h /usr/lib/python3.8/site-packages/pywal/templates/
			echo -e "\n${rby}DONE${reset}\n"

			break
			
		elif [[ "$opt" = "Individually" ]]; then

			read -p "$(echo -e "\nInstall ${rbb}DWM${r}? (y/${bold}N${reset}): ")" choice
			if [[ "$choice" = [Yy] ]]; then
				cd $HOME/dotfiles/
				stow suckless/

				sudo cp $HOME/dotfiles/configs/.config/wal/colors-wal-dwm.h /usr/lib/python3.8/site-packages/pywal/templates/
				
				sudo chmod 777 /usr/local/bin
				sudo chmod 777 /usr/local/man
				sudo chmod 777 /usr/local/man1

				cd $HOME/build/dwm/
				make &> /dev/null
				make install

				cd $HOME/build/st
				make &> /dev/null
				make install

				cd $HOME/build/dmenu
				make &> /dev/null
				make install

				cd $HOME/build/slock/
				make &> /dev/null
				sudo make install

				cd $HOME

				echo -e "\n${rby}DONE${reset}\n"
			else
				echo -e "\n${rbr}~${reset}\n"
			fi

			read -p "$(echo -e "Make symlinks for ${rbb}bash${reset} dotfiles? (y/${bold}N${reset}): ")" choice
			if [[ "$choice" = [Yy] ]]; then
				cd $HOME/dotfiles/
				stow bash/

				echo -e "\n${rby}DONE${reset}\n"
			else
				echo -e "\n${rbr}~${reset}\n" 
			fi

			read -p "$(echo -e "Make symlinks for ${rbb}X${reset} dotfiles? (y/${bold}N${reset}): ")" choice
			if [[ "$choice" = [Yy] ]]; then
				cd $HOME/dotfiles/
				stow x/
				echo -e "\n${rby}DONE${reset}\n"
			else
				echo -e "\n${rbr}~${reset}\n"
			fi

			read -p "$(echo -e "Make symlinks for ${rbb}vim${reset} dotfiles? (y/${bold}N${reset}): ")" choice
			if [[ "$choice" = [Yy] ]]; then
				cd $HOME/dotfiles/
				stow vim/
				echo -e "\n${rby}DONE${reset}\n"
			else
				echo -e "\n${rbr}~${reset}\n"
			fi

			read -p "$(echo -e "Make symlinks for ${rbb}tmux${reset} dotfiles? (y/${bold}N${reset}): ")" choice
			if [[ "$choice" = [Yy] ]]; then
				cd $HOME/dotfiles/
				stow tmux/
				echo -e "\n${rby}DONE${reset}\n"
			else
				echo -e "\n${rbr}~${reset}\n"
			fi

			read -p "$(echo -e "Make symlinks for ${rbb}scripts${reset} folder? (y/${bold}N${reset}): ")" choice
			if [[ "$choice" = [Yy] ]]; then
				cd $HOME/dotfiles/
				stow scripts/

				echo -e "\n${rby}DONE${reset}\n"
			else
				echo -e "\n${rbr}~${reset}\n"
			fi

			read -p "$(echo -e "Make symlinks for ${rbb}wallpapers${reset} folder? (y/${bold}N${reset}): ")" choice
			if [[ "$choice" = [Yy] ]]; then
				cd $HOME/dotfiles/
				stow images/
				echo -e "\n${rby}DONE${reset}\n"
			else
				echo -e "\n${rbr}~${reset}\n"
			fi

			break

		elif [[ "$opt" = "Skip" ]]; then
			echo -e "\n${rbr}~${reset}"
			break
		else
			echo -e "\n${rbr}~${reset}" 
		fi
	done

}


while [ -n "$1" ]; do
	case "$1" in
		-help)
			echo -e "install.sh usage: \n\tinstall.sh [options ...] \
			\n\nCommand line options: \
			\n\t${b}-help${r}\t\tShow this help message. \
			\n\t${b}-dotfiles${r}\tDownload and copy only dotfiles. \
			\n\t${b}-packages${r}\tInstall only packages from the official repositories and AUR. \
			\n\t${b}-list${r}\t\tShow a list of packages to be installed. \
			\n\t${b}-about${r}\t\tSome information about this script."
			exit	;;
		-dotfiles)
			clear
			dots
			echo -e "${bold}${red}\nThat's all\n${reset}"
			exit	;;
		-packages)
			pcmnpackages
			aurpackages
			exit ;;
		-list)
			echo -e "\
			\n${rby}Official repositories:${r} \
			\n$PP \
			\n\n${rbb}AUR:${r} \
			\n$PA"
			exit ;;
		-about)
			echo -e "${b}\nThis script will help download dotfiles from my GitHub repository and install basic packages for normal use of the system.${r}\n"
			exit ;;
		*)
			echo "$1 is not an option"
			exit	;;
	esac
	shift
done

clear

echo -e "${bold}${red}Let's start\n${reset}"


# Pacman #

pcmnpackages


# VirtualBox #

read -p "$(echo -e "Install ${rbb}VirtualBox${reset} additions? (y/${bold}N${reset}): ")" choice
if [[ "$choice" = [Yy] ]]; then
    sudo pacman -S xf86-video-vmware virtualbox-guest-utils virtualbox-guest-modules-arch --noconfirm
    echo -e "\n${rby}DONE${reset}\n"
else
	echo -e "\n${rbr}~${reset}\n"
fi


# yay #

read -p "$(echo -e "Install ${rby}yay${reset}? (y/${bold}N${reset}): ")" choice
if [[ "$choice" = [Yy] ]]; then
	git clone https://aur.archlinux.org/yay.git
	cd yay
	makepkg -si --noconfirm
	cd ..
	rm -rf yay/
	echo -e "\n${rby}DONE${reset}\n"
else
	echo -e "\n${rbr}~${reset}\n"
fi


# AUR #

aurpackages


# NVIDIA #

read -p "$(echo -e "Install ${rbg}NVIDIA${reset} proprietary driver? (y/${bold}N${reset}): ")" choice
if [[ "$choice" = [Yy] ]]; then
    yay -S nvidia-340xx-dkms --noconfirm
    echo -e "\n${rby}DONE${reset}\n"
else
	echo -e "\n${rbr}~${reset}\n"
fi


# Create directories #

folders


# Dotfiles #

dots


# Wallpaper #

read -p "$(echo -e "\nSet ${rbb}wallpaper${reset}? (y/${bold}N${reset}): ")" choice
if [[ "$choice" = [Yy] ]]; then
	wal -q -s -t -i $HOME/wallpapers/
	echo -e "\n${rby}DONE${reset}"
fi

echo -e "${bold}${red}\nThat's all\n${reset}"
