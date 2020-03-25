#!/bin/sh

PP=$(echo -e "xorg-server \nxorg-apps \nxorg-xinit \nleafpad \nalsa-utils \npulseaudio \nlibnotify \nchromium \npicom \npcmanfm \nsxiv \ndunst \npython-dbus \nmpd \nncmpcpp \nttf-font-awesome \nfeh \nnetworkmanager \nmaim \nttf-hack \nadapta-gtk-theme \ngit \ntumbler \nffmpegthumbnailer \ntransmission-gtk \nmpv \nttf-dejavu \ntmux \nttf-roboto \nttf-droid \nmpc \nyoutube-dl \ncurl \npamixer \nlxappearance \npacman-contrib \nxarchiver \nunzip \nman \nxclip \nxautolock \nstow \nw3m \nvim \nbc \nxdotool \ntelegram-desktop \nttf-opensans \nterminus-font \nfortune-mod \ntranslate-shell" | sort)

PA=$(echo -e "skb \nsublime-text-dev \npaper-icon-theme-git \nchromium-widevine" | sort)

pcmnpackages () {
	read -p "$(echo -e "Install base packages (pacman)? (y/N): ")" choice
	if [[ "$choice" = [Yy] ]]; then
		read -p "$(echo -e "\nShow package list? (y/N): ")" choice
		if [[ "$choice" = [Yy] ]]; then
			echo -e "\n$PP"
			read -p "$(echo -e "\nEdit package list? (y/N): ")" choice

			if [[ "$choice" = [Yy] ]]; then
				echo "$PP" > /tmp/packagelist.txt
				read -p "$(echo -e "\nEditor: ")" editor
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
			echo -e "${rby}\nDONE${reset}\n"
		else
			sudo pacman -S $(echo "$PP")
			rm /tmp/packagelist.txt &> /dev/null
			echo -e "\nDONE\n"
		fi
	else
		echo -e "\n~\n"
	fi
}

aurpackages () {
	read -p "$(echo -e "Install packages (AUR)? (y/N): ")" choice
	if [[ "$choice" = [Yy] ]]; then
		read -p "$(echo -e "\nShow package list? (y/N): ")" choice
		if [[ "$choice" = [Yy] ]]; then
			echo -e "\n$PA"
			read -p "$(echo -e "\nEdit package list? (y/}N): ")" choice
			if [[ "$choice" = [Yy] ]]; then
				echo "$PA" > /tmp/packagelistaur.txt
				read -p "$(echo -e "\nEditor: ")" editor
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
			echo -e "\nDONE\n"
		else
			yay -S $(echo "$PA")
			rm /tmp/packagelistaur.txt &> /dev/null
			echo -e "\nDONE\n"
		fi
	else
		echo -e "\n~\n"
	fi
}

lock_on_suspend () {
	sudo echo -e "[Unit]
Description=Lock X session using slock for user %i
Before=sleep.target

[Service]
User=%i
Environment=DISPLAY=:0
ExecStartPre=/usr/bin/xset dpms force suspend
ExecStart=/usr/bin/slock

[Install]
WantedBy=sleep.target" > /etc/systemd/system/slock@.service
sudo systemctl enable slock@ma.service
}

dotfiles () {

	echo
	echo '------------'
	echo '| DOTFILES |'
	echo '------------'

	read -p "$(echo -e "\nClone dotfiles and startpage from GitHub repository? (y/N): ")" choice
	if [[ "$choice" = [Yy] ]]; then
		cd $HOME/
	    git clone https://github.com/sadparadiseinhell/dotfiles.git
	    git clone https://github.com/sadparadiseinhell/sadparadiseinhell.github.io.git
	    echo -e "\nREPOSITORIES SUCCESSFULLY CLONED\n"
	else
		echo -e "\n~\n"
	fi

	echo -e "Make symlinks for all dotfiles or individually?\n"

	OPTIONS="$(echo -e 'All \nIndividually \nSkip')"
	select opt in $OPTIONS; do
		if [[ "$opt" = "All" ]]; then
			rm $HOME/.bashrc
			cd $HOME/dotfiles/
			stow bash/ bin/ colors/ configs/ images/ suckless/ tmux/ vim/ x/

			cd $HOME/build/dwm/
			make &> /dev/null
			sudo make install

			cd $HOME/build/st
			make &> /dev/null
			sudo make install

			cd $HOME/build/dmenu
			make &> /dev/null
			sudo make install

			cd $HOME/build/slock/
			make &> /dev/null
			sudo make install
			lock_on_suspend

			cd $HOME

			echo -e "\nDONE\n"

			break
			
		elif [[ "$opt" = "Individually" ]]; then

			read -p "$(echo -e "\nInstall dwm, st, dmenu and slock? (y/N): ")" choice
			if [[ "$choice" = [Yy] ]]; then
				cd $HOME/dotfiles/
				stow suckless/
				
				cd $HOME/build/dwm/
				make &> /dev/null
				sudo make install

				cd $HOME/build/st
				make &> /dev/null
				sudo make install

				cd $HOME/build/dmenu
				make &> /dev/null
				sudo make install

				cd $HOME/build/slock/
				make &> /dev/null
				sudo make install
				lock_on_suspend

				cd $HOME

				echo -e "\nDONE\n"
			else
				echo -e "\n~\n"
			fi

			read -p "$(echo -e "Make symlinks for bash dotfiles? (y/N): ")" choice
			if [[ "$choice" = [Yy] ]]; then
				cd $HOME/dotfiles/
				stow bash/

				echo -e "\nDONE\n"
			else
				echo -e "\n~\n" 
			fi

			read -p "$(echo -e "Make symlinks for X dotfiles? (y/N): ")" choice
			if [[ "$choice" = [Yy] ]]; then
				cd $HOME/dotfiles/
				stow x/
				echo -e "\nDONE\n"
			else
				echo -e "\n~\n"
			fi

			read -p "$(echo -e "Make symlinks for vim dotfiles? (y/N): ")" choice
			if [[ "$choice" = [Yy] ]]; then
				cd $HOME/dotfiles/
				stow vim/
				echo -e "\nDONE\n"
			else
				echo -e "\n~\n"
			fi

			read -p "$(echo -e "Make symlinks for tmux dotfiles? (y/N): ")" choice
			if [[ "$choice" = [Yy] ]]; then
				cd $HOME/dotfiles/
				stow tmux/
				echo -e "\nDONE\n"
			else
				echo -e "\n~\n"
			fi

			read -p "$(echo -e "Make symlinks for scripts folder? (y/N): ")" choice
			if [[ "$choice" = [Yy] ]]; then
				cd $HOME/dotfiles/
				stow scripts/

				echo -e "\nDONE\n"
			else
				echo -e "\n~\n"
			fi

			read -p "$(echo -e "Make symlinks for wallpapers folder? (y/N): ")" choice
			if [[ "$choice" = [Yy] ]]; then
				cd $HOME/dotfiles/
				stow images/
				echo -e "\nDONE\n"
			else
				echo -e "\n~\n"
			fi

			break

		elif [[ "$opt" = "Skip" ]]; then
			echo -e "\n~"
			break
		else
			echo -e "\n~" 
		fi
	done

}

while [ -n "$1" ]; do
	case "$1" in
		-help)
			echo -e "install.sh usage: \n\tinstall.sh [options ...] \
			\n\nCommand line options: \
			\n\t-help\t\tShow this help message. \
			\n\t-dotfiles\tDownload and copy only dotfiles. \
			\n\t-packages\tInstall only packages from the official repositories and AUR. \
			\n\t-list\t\tShow a list of packages to be installed. \
			\n\t-about\t\tSome information about this script."
			exit	;;
		-dotfiles)
			clear
			dotfiles
			echo -e "\nThat's all\n"
			exit	;;
		-packages)
			pcmnpackages
			aurpackages
			exit ;;
		-list)
			echo -e "\
			\nOfficial repositories: \
			\n$PP \
			\n\nAUR: \
			\n$PA"
			exit ;;
		-about)
			echo -e "\nThis script will help download dotfiles from my GitHub repository and install basic packages for normal use of the system.\n"
			exit ;;
		*)
			echo "$1 is not an option"
			exit ;;
	esac
	shift
done

clear

echo -e "Let's start\n"

pcmnpackages    # Install packages from official repositories

read -p "$(echo -e "Install VirtualBox additions? (y/N): ")" choice    # Install VirtualBox additions
if [[ "$choice" = [Yy] ]]; then
    sudo pacman -S xf86-video-vmware virtualbox-guest-utils virtualbox-guest-modules-arch --noconfirm
    echo -e "\nDONE\n"
else
	echo -e "\n~\n"
fi

read -p "$(echo -e "Install yay? (y/N): ")" choice    # Install yay
if [[ "$choice" = [Yy] ]]; then
	git clone https://aur.archlinux.org/yay.git
	cd yay
	makepkg -si --noconfirm
	cd ..
	rm -rf yay/
	echo -e "\nDONE\n"
else
	echo -e "\n~\n"
fi

aurpackages     # Install packages from AUR

read -p "$(echo -e "Install NVIDIA proprietary driver? (y/N): ")" choice    # Install NVIDIA driver
if [[ "$choice" = [Yy] ]]; then
    yay -S nvidia-340xx-dkms --noconfirm
    echo -e "\nDONE\n"
else
	echo -e "\n~\n"
fi

read -p "$(echo -e "Create folders for music, movies, screenshots? (y/N): ")" choice    # Create directories
if [[ "$choice" = [Yy] ]]; then
	mkdir $HOME/{music,movies,screenshots}
	echo -e "\nDONE\n"
fi

dotfiles    # Clone and install dotfiles

read -p "$(echo -e "\nSet wallpaper? (y/N): ")" choice    # Set wallpaper
if [[ "$choice" = [Yy] ]]; then
	feh -z --bg-fill $HOME/wallpapers/
	echo -e "\nDONE"
fi

echo -e "\nThat's all\n"
