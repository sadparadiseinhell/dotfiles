#!/bin/sh

PP=$(echo -e "xorg-server \nxorg-apps \nxorg-xinit \nleafpad \nalsa-utils \npulseaudio \nlibnotify \nchromium \npicom \npcmanfm \nsxiv \ndunst \npython-dbus \nmpd \nncmpcpp \nttf-font-awesome \nfeh \nnetworkmanager \nadapta-gtk-theme \ntumbler \nffmpegthumbnailer \ntransmission-gtk \nmpv \nttf-dejavu \nttf-roboto \nttf-droid \nmpc \nyoutube-dl \ncurl \npamixer \nlxappearance \npacman-contrib \nxarchiver \nunzip \nman \nxclip \nxautolock \nstow \nw3m \nneovim \nbc \nxdotool \ntelegram-desktop \nttf-opensans \nnoto-fonts \nmaim \nzsh \nzsh-completions \nwget \npapirus-icon-theme \nrofi \nwmctrl \nlightdm \nopenbox \ni3lock-color" | sort)

PA=$(echo -e "sublime-text-dev \nchromium-widevine \npolybar" | sort)

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
			read -p "$(echo -e "\nEdit package list? (y/N): ")" choice
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

vim_plug () {
	curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
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

	echo -e '\n------------'
	echo '| DOTFILES |'
	echo '------------'

	read -p "$(echo -e "\nClone startpage from GitHub repository? (y/N): ")" choice
	if [[ "$choice" = [Yy] ]]; then
		cd $HOME/
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
			stow bin/ colors/ configs/ images/ suckless/ tmux/ x/ zsh/ bash/

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

			cd $HOME

			vim_plug

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

			read -p "$(echo -e "Make symlinks for config dotfiles? (y/N): ")" choice
			if [[ "$choice" = [Yy] ]]; then
				cd $HOME/dotfiles/
				stow configs/
				vim_plug
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

## Install packages from official repositories
pcmnpackages

## Install VirtualBox additions
read -p "$(echo -e "Install VirtualBox additions? (y/N): ")" choice
if [[ "$choice" = [Yy] ]]; then
    sudo pacman -S xf86-video-vmware virtualbox-guest-utils virtualbox-guest-modules-arch --noconfirm
    echo -e "\nDONE\n"
else
	echo -e "\n~\n"
fi

## Install yay
read -p "$(echo -e "Install yay? (y/N): ")" choice
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

## Install packages from AUR
aurpackages

## Install NVIDIA driver
read -p "$(echo -e "Install NVIDIA proprietary driver? (y/N): ")" choice
if [[ "$choice" = [Yy] ]]; then
    yay -S nvidia-340xx-dkms --noconfirm
    echo -e "\nDONE\n"
else
	echo -e "\n~\n"
fi

## Create directories
read -p "$(echo -e "Create folders for music, movies, screenshots? (y/N): ")" choice
if [[ "$choice" = [Yy] ]]; then
	mkdir $HOME/{music,movies,screenshots}
	echo -e "\nDONE\n"
fi

## Clone and install dotfiles
dotfiles

## Set wallpaper
read -p "$(echo -e "\nSet wallpaper? (y/N): ")" choice
if [[ "$choice" = [Yy] ]]; then
	feh -z --bg-fill $HOME/wallpapers/
	echo -e "\nDONE"
fi

echo -e "\nThat's all\n"
