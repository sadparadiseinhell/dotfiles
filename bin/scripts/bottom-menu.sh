#!/bin/sh

ROFICOMMAND='rofi -theme slate.rasi'

# Power -----------------------------------

function power {
	shutdown="  Shutdown"
	reboot="  Reboot"
	lock="  Lock"
	suspend="  Suspend"
	logout="  Logout"

	options="$shutdown\n$reboot\n$lock\n$suspend\n$logout"
	chosen="$(echo -e "$options" | $ROFICOMMAND -i -width 280 -dmenu -selected-row 2 -columns 1 -lines 5 -p '  Power:')"

	execute () {
		case $chosen in
			$shutdown)
				ACTION="systemctl poweroff"
				;;
			$reboot)
				ACTION="systemctl reboot"
				;;
			$suspend)
				ACTION="systemctl suspend"
				;;
			$lock)
				ACTION="$HOME/scripts/lock.sh"
				;;
			$logout)
				ACTION="openbox --exit"
				;;
		esac
	
		if [[ $chosen = $shutdown ]] && [[ $confirm = $yes ]]; then
			paplay '/usr/share/sounds/freedesktop/stereo/service-logout.oga'
		fi

		[[ $confirm = $yes ]] && $ACTION
	}
	
	yes='   Yes'
	no='    No'

	options="$yes\n$no"

	confirm () {
		if [[ -z $chosen ]]; then
			exit 0
		else
			confirm="$(echo -e "$options" | $ROFICOMMAND -i -width 280 -dmenu -selected-row 1 -columns 2 -lines 1 -p '  Confirm:')"
		fi
	}

	confirm && execute

	exit 0
}

# Music Control -----------------------------------

function music_control {
	status="$(mpc status)"

	if [[ $status == *"[playing]"* ]]; then
	    play_pause=""
	else
	    play_pause=""
	fi
	active=""
	urgent=""
	
	tog_repeat=""
	if [[ $status == *"repeat: on"* ]]; then
	    active="-a 4"
	elif [[ $status == *"repeat: off"* ]]; then
	    urgent="-u 4"
	else
	    tog_repeat=" Parsing error"
	fi
	
	tog_random=""
	if [[ $status == *"random: on"* ]]; then
	    [ -n "$active" ] && active+=",5" || active="-a 5"
	elif [[ $status == *"random: off"* ]]; then
	    [ -n "$urgent" ] && urgent+=",5" || urgent="-u 5"
	else
	    tog_random=" Parsing error"
	fi
	stop=""
	next=""
	previous=""
	
	options="$previous\n$stop\n$play_pause\n$next\n$tog_repeat\n$tog_random"
	
	NUM=$(mpc -f %title% current | wc -c)
	if [[ $NUM -ge '40' ]]; then
	    current=$(echo $(mpc -f "%artist% - %title%" current | cut -c -43)...)
	elif [[ -z "$(mpc -f %title% current)" ]]; then
	    current="(・_・;)"
	else
	    current=$(mpc -f "%artist% - %title%" current)
	fi
	
	chosen="$(echo -e "$options" | rofi -theme mpd.rasi -width 330 -dmenu $active $urgent -selected-row 2 -p "$current")"
	case $chosen in
	    $previous)
	        mpc -q prev
	        ;;
	    $play_pause)
	        $HOME/scripts/musicctrl.sh play
	        ;;
	    $stop)
	        mpc -q stop
	        ;;
	    $next)
	        mpc -q next
	        ;;
	    $tog_repeat)
	        mpc -q repeat
	        if [[ $status == *"repeat: off"* ]]; then
	            notify-send 'Repeat mode is on' -t 2000
	        else
	            notify-send 'Repeat mode is off' -t 2000
	        fi
	        ;;
	    $tog_random)
	        mpc -q random
	        if [[ $status == *"random: off"* ]]; then
	            notify-send 'Random mode is on' -t 2000
	        else
	            notify-send 'Random mode is off' -t 2000
	        fi
	        ;;
	esac
}

# Music -----------------------------------

function music {
	launcher='rofi -dmenu -width 280 -theme slate'

	control='  Control'
	library='  Library'
	album='  Albums'
	song='  Songs'
	
	artist() {
		lines(){ mpc list artist | wc -l ; }
		lines=$(lines)
		[ "$(lines)" -gt 8 ] && lines=8
		mpc list artist | sort -f | $launcher -i -p "$library:" -l $lines -columns 1
	}
	
	a_album() {
		artist="$1"
		lines(){ mpc list album artist "$artist" | wc -l ; }
		lines=$(lines)
		[ "$(lines)" -gt 8 ] && lines=8
		mpc list album artist "$artist" | sort -f | $launcher -i -p "$album " -l $lines
	}
	
	album() {
		lines(){ mpc list album | wc -l ; }
		lines=$(lines)
		[ "$(lines)" -gt 8 ] && lines=8
		mpc list album | sort -f | $launcher -i -p "$album:" -l $lines -columns 1
	}
	
	song() {
		lines(){ mpc list title | wc -l ; }
		lines=$(lines)
		[ "$(lines)" -gt 8 ] && lines=8
		mpc list title | sort -f | $launcher -i -p "$song:" -l $lines
	}
	
	options="$control\n$library\n$album\n$song"
	opt="$(echo -e "$options" | $ROFICOMMAND -i -width 280 -l 4 -dmenu -selected-row 0 -p '  Music:')"
	case $opt in
		$control)
			music_control
			;;
		$library)
			artist=$(artist)
			[ ! "$artist" ] && exit
			album=$(a_album "$artist")
			[ ! "$album" ] && exit
			mpc clear > /dev/null
			mpc find artist "$artist" album "$album" | mpc add
			$HOME/scripts/musicctrl.sh play
			;;
		$song)
			song=$(song)		
			[ ! "$song" ] && exit
			mpc clear > /dev/null
			mpc search title "$song" | mpc add
			$HOME/scripts/musicctrl.sh play
			;;
		$album)
			album=$(album)
			[ ! "$album" ] && exit
			mpc clear > /dev/null
			mpc find album "$album" | mpc add
			$HOME/scripts/musicctrl.sh play
			;;
	esac
}

# Screenshot -----------------------------------

function screenshot {
	sound='/usr/share/sounds/freedesktop/stereo/camera-shutter.oga'
	scrotdir="$HOME/screenshots/"
	name="$(date +%G_%m_%d_%T).png"
	file="/tmp/scrot.png"

	notification () {
		action=$(dunstify -A O,action 'Screenshot saved' "$name" -i $file -t 2500)
		[[ $action = 'O' ]] && xdg-open $scrotdir 2> /dev/null && exit &
		#[[ $action = 'O' ]] && xdg-open $scrotdir/$name 2> /dev/null && exit &
	}
	
	countdown () {
		if [[ -z $2 ]]; then
			t='3'
		else
			t=$2
		fi
		
		for (( i = $t; i > 0; i-- )); do
			dunstify -r 1338 -t 1050 "Screenshot" "Taking shot in $i seconds"
			sleep 1
		done
	}

	screen='  Fullscreen'
	area='  Area'
	window='  Window'
	
	options="$screen\n$area\n$window"
	opt="$(echo -e "$options" | $ROFICOMMAND -i -width 280 -dmenu -selected-row 0 -lines 3 -p '  Screenshot:')"
	execute () {
		case $opt in
			$screen)
				ACTION="maim -u $file"
				;;
			$area)
				ACTION="maim -s $file"
				;;
			$window)
				ACTION="maim -u -i $(xdotool getactivewindow) $file"
				;;
		esac
	
		if [[ $opt = $screen ]] && [[ $location = $disc ]]; then
			countdown $@
		fi

		if [[ $location = $clip ]]; then
			sleep .5
			$ACTION
			xclip -selection clipboard -t image/png < $file
			notify-send -i $file "Screenshot copied to clipboard"
		elif [[ $location = $disc ]]; then
			sleep .5
			$ACTION
			notification &
			paplay $sound
			mv $file $scrotdir/$name
		fi
	}
	
	location () {
		clip="  Clipboard" #
		disc="  Storage" #
	
		conf="$clip\n$disc"
	
		if [[ -z $opt ]]; then
			exit 0
		else
			location="$(echo -e "$conf" | $ROFICOMMAND -i -width 280 -dmenu -selected-row 1 -columns 2 -lines 1 -p '  Save to:')"
		fi
	}
	
	location && execute $@
	
	exit 0
}

# Wallpaper -----------------------------------

function wallpaper {
	walldir="$HOME/wallpapers"
	
	unsplash () {
		pic="$HOME/.cache/wallpaper_unsplash.jpg"
		chosen=$(rofi -i -dmenu -l 0 -width 280 -theme slate -p '  Enter search term:')
		
		if [[ -z $chosen ]]; then
			exit 0
		elif [[ $chosen = 'daily' ]]; then
			wget -O $pic https://source.unsplash.com/daily
		elif [[ $chosen = 'random' ]]; then
			wget -O $pic https://source.unsplash.com/random/1920x1080
		else
			p="$(echo "?$chosen" | sed -e 's/ /\,/g')"
			wget -O $pic https://source.unsplash.com/featured/1920x1080/$p
		fi
		
		feh --bg-fill $pic
		notify-send "New wallpaper set" -t 3200
		scripts/lock.sh -i $(cat .fehbg | tail -n 1 | awk '{print $4}' | sed s/\'//g)
		cp $HOME/.cache/lockscreen/resize-blur.png /dm/background.jpg
	}
	
	local_storage () {
		width=$(xrandr --current | grep '*' | awk '{print $1}' | sed 's/x/ /' | awk '{print $1}')
		height=$(xrandr --current | grep '*' | awk '{print $1}' | sed 's/x/ /' | awk '{print $2}')
		x=$(echo "($width-800)/2" | bc)
		y=$(echo "($height-600)/2" | bc)
		location=$(echo 800x600+$x+$y)
		walls=$(sxiv -t -o -r -b -g $location $walldir | xargs)
		selwall=$(echo "$walls" | awk '{w = 1; for (--w; w >=0; w--){printf "%s\t",$(NF-w)}print ""}')
	
		[[ -z $(echo $selwall) ]] && exit 0
		
		#chosen=$(ls $walldir | $LAUNCHER -i -p "Select wallpaper " )
		#[[ -z $chosen ]] && exit 0
	
		feh --bg-fill $(echo $selwall)
		notify-send "$(echo $selwall | sed 's/\// /g' | awk '{print $4}') set as wallpaper" -t 3200
		scripts/lock.sh -i $(cat .fehbg | tail -n 1 | awk '{print $4}' | sed s/\'//g)
		cp $HOME/.cache/lockscreen/resize-blur.png /dm/background.jpg
	}
	
	unsplash='  Unsplash'
	local='  Local Storage'
	
	options="$unsplash\n$local"
	opt="$(echo -e "$options" | $ROFICOMMAND -i -width 280 -dmenu -selected-row 0 -columns 2 -lines 1 -p '  Wallpapers:')"
	case $opt in
		$unsplash)
			unsplash
			;;
		$local)
			local_storage
			;;
	esac
}

# Video -----------------------------------

function video {
	rofi="rofi -dmenu -width 280 -theme slate"
	DOWNLOADS_DIR="$HOME/movies/downloads/"
	
	local_storage () {
		DIR="$HOME/movies/"
		CHOICE="$(ls --group-directories-first $DIR | $rofi -l 4 -p '  Select video:')"
		if [[ -n $CHOICE ]] && [[ "$CHOICE" = *.mkv ]]; then
			if [[ -z $CHOICE ]]; then
				exit 0
			fi
			mpv "$DIR$CHOICE"
			exit 0
		elif [[ -n $CHOICE ]] && [[ -d "$DIR$CHOICE" ]]; then
			if [[ -z $CHOICE ]]; then
				exit 0
			fi
			cd "$DIR$CHOICE"
			NUM=$(ls "$DIR$CHOICE" | grep "\.mkv\|\.avi\|\.mp4" | wc -l)
			if [[ $NUM -gt 1 ]]; then
				cd "$DIR$CHOICE"
				CHOICE="$(ls $PWD | $rofi -l 4 -p '  Select video:')"
				if [[ -z $CHOICE ]]; then
					exit 0
				fi
				DIR="$PWD/"
				if [[ -n $CHOICE ]]; then
					mpv "$DIR$CHOICE"
					exit 0
				fi
			fi
			mpv *{.mkv,.avi,.mp4}
			if [[ $? != 0 ]]; then
				cd $(ls $DIR$CHOICE)
				mpv *{.mkv,.avi,.mp4}
				exit 0
			fi
		else
			exit 0
		fi
	
		if [[ $? != 0 ]]; then
			notify-send -u critical -t 3000 "Video can't be opened"
		fi
	}
	
	by_link () {
		LINK=$( (echo | grep 0) | $rofi -l 0 -i -p '  Paste a link to a video:')
		if [[ -n $LINK ]]; then
			mpv --ytdl-format="[height=720]" $LINK
		else
			exit 0
		fi
	
		if [[ $? != 0 ]]; then
			notify-send -u critical -t 3000 "Video can't be opened"
		fi
	}
	
	download () {
		if [[ ! -d $DOWNLOADS_DIR ]]; then
			mkdir $DOWNLOADS_DIR
		fi
	
		LINK=$(echo | grep 0 | $rofi -l 0 -i -p '  Paste a link to a video:')
		if [[ -z $LINK ]]; then
			exit 0
		fi
	
		QUALITY=$(echo -e '480\n720\n1080' | $rofi -l 3 -i -p '  Quality:')
		if [[ -z $QUALITY ]]; then
			QUALITY='1080'
		fi
	
		if [[ $QUALITY != '1080' ]] && [[ $QUALITY != '720' ]] && [[ $QUALITY != '480' ]]; then
			exit 0
		fi
	
		cd $DOWNLOADS_DIR
		youtube-dl -f bestvideo[height=$QUALITY]+bestaudio[ext=m4a] --merge-output-format mkv $LINK
	
		if [[ $? != 0 ]]; then
			notify-send -u critical -t 3000 "Video can't be downloaded"
			exit 0
		else
			notify-send -t 2000 'Video downloaded'
		fi
	}
	
	yt_search () {
		INPUT=$(echo | grep 0 | $rofi -l 0 -i -p '  Search:')
		if [[ -n $INPUT ]]; then
			mpv --ytdl-format="bestvideo[height<=1080]+bestaudio" ytdl://ytsearch:"$INPUT"
		else
			exit 0
		fi
	
		if [[ $? != 0 ]]; then
			notify-send -u critical -t 3000 "Video can't be opened"
		fi
	}
	
	twitch () {
		LINK=$(echo | grep 0 | $rofi -l 0 -i -p '  Paste a link:')
		if [[ -n $LINK ]]; then
			mpv --ytdl-format="720p+bestaudio" $LINK
		else
			exit 0
		fi
	
		if [[ $? != 0 ]]; then
			notify-send -u critical -t 3000 "Video can't be opened"
		fi
	}
	
	link='  Link'
	local='  Local'
	download='  Download'
	search='  YouTube Search'
	twitch='  Twitch'
	
	options="$link\n$local\n$search\n$download\n$twitch"
	opt="$(echo -e "$options" | $ROFICOMMAND -i -width 280 -dmenu -selected-row 0 -columns 2 -lines 3 -p '  Video:')"
	case $opt in
		$link)
			by_link
			;;
		$local)
			local_storage
			;;
		$download)
			download
			;;
		$search)
			yt_search
			;;
		$twitch)
			twitch
			;;
		*)
			exit 0
			;;
	esac
}

# Updates -----------------------------------

function updates {
	NUM=$(checkupdates | wc -l)
	if [[ $NUM -gt 8 ]]; then
		HEIGHT='8'
	else
		HEIGHT=$NUM
	fi
	
	show_updates () {
		if [[ -z $(checkupdates) ]]; then
			notify-send "$(printf 'There is nothing to do!')" -t 2000
			exit 0
		else
			list=$(echo "$(checkupdates)" | rofi -i -width 280 -theme slate -dmenu -l $HEIGHT -p "$(echo "  $NUM") updates " )
		fi
		
		[[ -z $list ]] && exit 0
		
		yes='  Yes'
		no='  No'

		options="$yes\n$no"
		second_menu="$(echo -e "$options" | $ROFICOMMAND -i -width 280 -dmenu -selected-row 1 -columns 2 -lines 1 -p '  Update:')"
		
		export SUDO_ASKPASS="/home/ma/scripts/askpass.sh"
		
		if [[ $second_menu = $yes ]]; then
			sudo -A pacman -Syu --noconfirm
			if [[ $? -eq 0 ]]; then
				notify-send 'Update completed successfully!'
			else
				notify-send 'Error!'
				exit 0
			fi
			exit 0
		else
			exit 0
		fi
	}
	
	show_updates

	#update_system () {
	#	if [[ -z $(checkupdates) ]]; then
	#		notify-send "$(printf 'No updates available\nPls try again later')" -t 2000
	#	else
	#		st -T 'update' -c 'updates' -g 75x25 -e sudo pacman -Syu --noconfirm
	#		notify-send 'Update completed successfully'
	#	fi
	#	exit 0
	#}
	#
	#show=''
	#update=''
	#
	#options="$show\n$update"
	#opt="$(echo -e "$options" | $ROFICOMMAND -width 145 -dmenu -selected-row 0)"
	#case $opt in
	#	$show)
	#		show_updates
	#		;;
	#	$update)
	#		update_system
	#		;;
	#	*)
	#		exit 0
	#		;;
	#esac
}

# Screencast -----------------------------------

function screencast {
	name="$(date +%G_%m_%d_%T)_screencast.mp4"
	
	start () {
		echo 'start'
		notify-send 'Screencast recording started' -t 1000
		sleep 1
		ffmpeg -f x11grab  -y -rtbufsize 100M -s 1680x1050 -framerate 30 -probesize 10M -draw_mouse 0 -i :0.0 -c:v libx264 -r 30 -preset ultrafast -tune zerolatency -crf 25 -pix_fmt yuv420p $HOME/screenshots/$name
	}

	stop () {
		echo 'stop'
		killall ffmpeg
		notify-send 'Screencast saved!' -t 2000
	}
	
	start=''
	stop=''
	
	options="$start\n$stop"
	opt="$(echo -e "$options" | $ROFICOMMAND -width 140 -dmenu -selected-row 0)"
	case $opt in
		$start)
			start
			;;
		$stop)
			stop
			;;
	esac
}

# To-Do -----------------------------------

function todo {
	FILE="$HOME/.todo.txt"
	touch "$FILE"
	HEIGHT=$(wc -l "$FILE" | awk '{print $1}')
	PROMPT='  Add/Delete:'
	SOUND='/usr/share/sounds/freedesktop/stereo/dialog-information.oga'

	CMD=$(rofi -dmenu -i -width 280 -theme slate -l "$HEIGHT" -p "$PROMPT" "$@" < "$FILE")
	while [ -n "$CMD" ]; do
	 	if grep -q "^$CMD\$" "$FILE"; then
			grep -v "^$CMD\$" "$FILE" > "$FILE.$$"
			mv "$FILE.$$" "$FILE"
	        HEIGHT=$(( HEIGHT - 1 ))
	 	else
			echo "$CMD" >> "$FILE"
			HEIGHT=$(( HEIGHT + 1 ))
			paplay "$SOUND" 2>/dev/null &
	 	fi
	
		CMD=$(rofi -dmenu -i -width 280 -theme slate -l "$HEIGHT" -p "$PROMPT" "$@" < "$FILE")
	done
	exit 0
}

# Menu -----------------------------------

function menu {
	second_menu () {
		function calculator {
			LAUNCHER='rofi -dmenu -width 280 -theme slate'
			while true; do
				MAIN=$(echo | grep 0 | $LAUNCHER -l 0 -i -p '  Enter an example:')
				if [[ -z $MAIN ]]; then
					exit 0
				fi
				RES=$(echo $MAIN | bc | $LAUNCHER -l 1 -i -p '  Result:')
				if [[ -z $RES ]]; then
					exit 0
				fi
			done
		}

		apps='  Apps'
		screencast='  Screencast'
		timer='  Timer'
		theme='  Theme'
		calculator='  Calculator'
	
		options="$apps\n$calculator\n$timer\n$theme\n$screencast"
		opt="$(echo -e "$options" | $ROFICOMMAND -i -width 280 -dmenu -l 5 -selected-row 0 -p '  Menu:')"

		case $opt in
			$screencast)
				$HOME/scripts/awesome-menu-mix.sh -sc
				;;
			$timer)
				$HOME/projects/rofi-menus/tinytimer.sh
				;;
			$calculator)
				calculator
				;;
			$apps)
				rofi -show drun -theme slate -width 280 -p '  Apps'
				;;
			$theme)
				$HOME/scripts/theme-control.sh -c
				;;
		esac
	}
	
	power='  Power'
	screenshot='  Screenshot'
	music='  Music'
	wallpapers='  Wallpapers'
	todo='  To-Do'
	video='  Video'
	updates='  Updates'
	other='  Other'
	
	options="$power\n$screenshot\n$music\n$wallpapers\n$todo\n$video\n$updates\n$other"
	opt="$(echo -e "$options" | $ROFICOMMAND -i -width 280 -dmenu -selected-row 0 -p '  Menu:')"

	case $opt in
		$power)
			$HOME/scripts/bottom-menu.sh -p
			;;
		$screenshot)
			$HOME/scripts/bottom-menu.sh -s
			;;
		$music)
			$HOME/scripts/bottom-menu.sh -m
			;;
		$wallpapers)
			$HOME/scripts/bottom-menu.sh -w
			;;
		$todo)
			todo
			;;
		$video)
			$HOME/scripts/bottom-menu.sh -v
			;;
		$updates)
			$HOME/scripts/bottom-menu.sh -u
			;;
		$other)
			second_menu
			;;
	esac
}

case $1 in
	-p)
		power
		;;
	-m)
		music
		;;
	-s)
		screenshot
		;;
	-w)
		wallpaper
		;;
	-v)
		video
		;;
	-u)
		updates
		;;
	-sc)
		screencast
		;;
	-g)
		menu
		;;
	-mc)
		music_control
		;;
esac