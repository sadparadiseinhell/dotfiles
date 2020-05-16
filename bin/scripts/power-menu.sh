#!/bin/sh

source $HOME/scripts/launcher.sh

menu () {
	opt="$(printf 'Lock\nLogout\nSuspend\nHibernate\nReboot\nPoweroff' | $LAUNCHER -i -p 'Power menu ')"
	execute () {
		case $opt in
			Poweroff) ACTION="systemctl poweroff";;
			Reboot) ACTION="systemctl reboot";;
			Hibernate) ACTION="systemctl hibernate";;
			Suspend) ACTION="systemctl suspend";;
			Lock) ACTION="$HOME/scripts/lock.sh" ;;
			Logout) ACTION="/usr/bin/killall xinit" ;;
		esac
	
		if [[ $opt = 'Poweroff' ]] && [[ $confirm = 'Yes' ]]; then
			paplay '/usr/share/sounds/freedesktop/stereo/service-logout.oga'
		fi
	
		if [[ $confirm = 'Yes' ]]; then
			$ACTION
		elif [[ $confirm = 'No' ]]; then
			echo ':('
		fi
	}
	
	confirm () {
		if [[ -z $opt ]]; then
			exit 0
		else
			confirm=$(printf 'No\nYes' | $LAUNCHER -i -p "$opt ")
		fi
	}
	
	confirm && execute
	
	exit 0

}

applet () {
	rofi_command="rofi -theme powermenu.rasi"
	uptime=$(uptime -p | sed -e 's/up //g')
	
	shutdown=""
	reboot=""
	lock=""
	suspend=""
	logout=""
	
	options="$shutdown\n$reboot\n$lock\n$suspend\n$logout"
	
	chosen="$(echo -e "$options" | $rofi_command -p "UP - $uptime" -dmenu -selected-row 2)"
	case $chosen in
	    $shutdown)
			paplay '/usr/share/sounds/freedesktop/stereo/service-logout.oga'
	        systemctl poweroff
	        ;;
	    $reboot)
	        systemctl reboot
	        ;;
	    $lock)
	        $HOME/scripts/lock.sh
	        ;;
	    $suspend)
	        mpc -q pause
	        #pamixer -t
	        systemctl suspend
	        ;;
	    $logout)
	        openbox --exit
	        ;;
	esac
}

case $1 in
	-m)
		menu
		;;
	-a)
		applet
		;;
	*)
		menu
		;;
esac