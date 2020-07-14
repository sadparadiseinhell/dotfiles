#!/bin/sh

DUNST_PATH="$HOME/.colors/dunst/dunstrc-colored"
SCRIPT=awesome-menu.sh
THEME=mix.rasi
WIDTH=270

function change {
	function mix {
		sed -i -e '0,/geometry/s/geometry = .*/geometry = "300x0-10+40"/' $DUNST_PATH
		killall dunst
		dunst -config $HOME/.colors/dunst/dunstrc-colored &

		sed -i -e '0,/ROFICOMMAND/s/ROFICOMMAND=.*/ROFICOMMAND="rofi -theme $MIX"/g' $HOME/scripts/global-rofi-menu.sh
		sed -i -e '0,/THEME/s/THEME=.*/THEME=mix.rasi/g' $0
		sed -i -e '0,/WIDTH/s/WIDTH=.*/WIDTH=270/g' $0
		polybar-msg cmd quit
		$HOME/.config/polybar/2c/launch.sh
	}
	
	function slate {
		sed -i -e '0,/geometry/s/geometry = .*/geometry = "300x0-10+10"/' $DUNST_PATH
		killall dunst
		dunst -config $HOME/.colors/dunst/dunstrc-colored &

		sed -i -e '0,/ROFICOMMAND/s/ROFICOMMAND=.*/ROFICOMMAND="rofi -theme $SLATE"/g' $HOME/scripts/global-rofi-menu.sh
		sed -i -e '0,/THEME/s/THEME=.*/THEME=slate.rasi/g' $0
		sed -i -e '0,/WIDTH/s/WIDTH=.*/WIDTH=280/g' $0
		polybar-msg cmd quit
		$HOME/.config/polybar/launch.sh
	}

	function mono {
		sed -i -e '0,/geometry/s/geometry = .*/geometry = "300x0-10+40"/' $DUNST_PATH
		killall dunst
		dunst -config $HOME/.colors/dunst/dunstrc-colored &

		sed -i -e '0,/ROFICOMMAND/s/ROFICOMMAND=.*/ROFICOMMAND="rofi -theme $MIX"/g' $HOME/scripts/global-rofi-menu.sh
		sed -i -e '0,/THEME/s/THEME=.*/THEME=mix.rasi/g' $0
		sed -i -e '0,/WIDTH/s/WIDTH=.*/WIDTH=270/g' $0
		polybar-msg cmd quit
		$HOME/.config/polybar/mono/launch.sh
	}
	
	mix='Mix'
	slate='Slate'
	mono='Monochrome'
		
	options="$mix\n$slate\n$mono"

	lines=$(echo -e $options | wc -l)
	[ $lines -gt 4 ] && lines=4

	opt="$(echo -e "$options" | rofi -show -theme $THEME -width $WIDTH -l $lines -i -dmenu -selected-row 0 -p '  Theme:')"
	
	case $opt in
		$mix)
			mix
			;;
		$slate)
			slate
			;;
		$mono)
			mono
			;;
	esac
}

function switch {
	## Dirs ##
	
	DUNST_PATH="$HOME/.colors/dunst/dunstrc-colored"
	POLYBAR_PATH="$HOME/.config/polybar/2c"
	ROFI_COLORS_PATH="$HOME/.config/rofi/colors.rasi"
	
	## Dark mode ##
	
	if [[ $(cat $POLYBAR_PATH/colors.ini | grep fg) = "fg = #222222" || $1 = "-d" ]]; then
	
	# dunst -----------------------------------
		sed -i -e 's/background = .*/background = "#0f1217"/g' $DUNST_PATH
		sed -i -e 's/frame_color = .*/frame_color = "#0f1217"/g' $DUNST_PATH
		sed -i -e '127,132s/foreground = .*/foreground = "#f2f2f2"/' $DUNST_PATH
	
		killall dunst
		dunst -config $HOME/.colors/dunst/dunstrc-colored &
	
	# polybar ---------------------------------
		sed -i -e 's/bg = .*/bg = #F20f1217/g' $POLYBAR_PATH/colors.ini
		sed -i -e 's/bg-alt = .*/bg-alt = #5C6F7B/g' $POLYBAR_PATH/colors.ini
		sed -i -e 's/fg = .*/fg = #E0E2E1/g' $POLYBAR_PATH/colors.ini
		sed -i -e 's/ac = .*/ac = #4DD0E1/g' $POLYBAR_PATH/colors.ini
		
		sed -i -e 's/red = .*/red = #EC7875/g' $POLYBAR_PATH/colors.ini
		sed -i -e 's/pink = .*/pink = #EC407A/g' $POLYBAR_PATH/colors.ini
		sed -i -e 's/purple = .*/purple = #BA68C8/g' $POLYBAR_PATH/colors.ini
		sed -i -e 's/blue = .*/blue = #42A5F5/g' $POLYBAR_PATH/colors.ini
		sed -i -e 's/cyan = .*/cyan = #4DD0E1/g' $POLYBAR_PATH/colors.ini
		sed -i -e 's/teal = .*/teal = #00B19F/g' $POLYBAR_PATH/colors.ini
		sed -i -e 's/green = .*/green = #61C766/g' $POLYBAR_PATH/colors.ini
		sed -i -e 's/lime = .*/lime = #B9C244/g' $POLYBAR_PATH/colors.ini
		sed -i -e 's/yellow = .*/yellow = #FDD835/g' $POLYBAR_PATH/colors.ini
		sed -i -e 's/amber = .*/amber = #FBC02D/g' $POLYBAR_PATH/colors.ini
		sed -i -e 's/orange = .*/orange = #E57C46/g' $POLYBAR_PATH/colors.ini
		sed -i -e 's/brown = .*/brown = #AC8476/g' $POLYBAR_PATH/colors.ini
		sed -i -e 's/indigo = .*/indigo = #6C77BB/g' $POLYBAR_PATH/colors.ini
	
		sed -i -e 's/content = /content = /' $POLYBAR_PATH/user_modules.ini
		sed -i -e '323,325s/content-foreground = .*/content-foreground = #FEE049/' $POLYBAR_PATH/user_modules.ini
		
		## monochrome -------------------------
		sed -i -e 's/bg = .*/bg = #F20f1217/g' $HOME/.config/polybar/mono/colors.ini
		sed -i -e 's/bg-alt = .*/bg-alt = #516D6F/g' $HOME/.config/polybar/mono/colors.ini
		sed -i -e 's/fg = .*/fg = #f2f2f2/g' $HOME/.config/polybar/mono/colors.ini
		sed -i -e 's/fg-alt = .*/fg-alt = #B7B7B7/g' $HOME/.config/polybar/mono/colors.ini
	
		sed -i -e '452,456s/format-prefix-foreground = .*/format-prefix-foreground = ${color.yellow}/' $HOME/.config/polybar/mono/modules.ini
	
		sed -i -e '323,326s/content-foreground = .*/content-foreground = ${color.amber}/' $HOME/.config/polybar/mono/user_modules.ini
	# relaunch polybar ------------------------
		polybar-msg cmd restart
	
	# rofi ------------------------------------
		sed -i -e '0,/shade1/s/shade1: .*/shade1: #0f1217F2;/g' $ROFI_COLORS_PATH
		sed -i -e '0,/shade2/s/shade2: .*/shade2: #cccccc99;/g' $ROFI_COLORS_PATH
		sed -i -e '0,/shade3/s/shade3: .*/shade3: #f7eef5;/g' $ROFI_COLORS_PATH
		sed -i -e '0,/shade4/s/shade4: .*/shade4: #0f1217B3;/g' $ROFI_COLORS_PATH
	
	# st --------------------------------------
		sed -i -e '0,/background/s/*.background: .*/*.background:        #0f1217/g' $HOME/.Xresources
		sed -i -e '0,/foreground/s/*.foreground: .*/*.foreground:        #f7eef5/g' $HOME/.Xresources
	
		xrdb -load $HOME/.Xresources
	
	## Light mode ##
	
	elif [[ $(cat $POLYBAR_PATH/colors.ini | grep fg) = "fg = #E0E2E1" || $1 = "-l" ]]; then
	
	# dunst -----------------------------------	
		sed -i -e 's/background = .*/background = "#ffffff"/g' $DUNST_PATH
		sed -i -e 's/frame_color = .*/frame_color = "#ffffff"/g' $DUNST_PATH
		sed -i -e '127,132s/foreground = .*/foreground = "#0f1217"/' $DUNST_PATH
		
		killall dunst
		dunst -config $HOME/.colors/dunst/dunstrc-colored &
	# polybar ---------------------------------
		sed -i -e 's/bg = .*/bg = #FFFFFF/g' $POLYBAR_PATH/colors.ini
		sed -i -e 's/bg-alt = .*/bg-alt = #CACACA/g' $POLYBAR_PATH/colors.ini
		sed -i -e 's/fg = .*/fg = #222222/g' $POLYBAR_PATH/colors.ini
		sed -i -e 's/ac = .*/ac = #4DA8B9/g' $POLYBAR_PATH/colors.ini
		
		sed -i -e 's/red = .*/red = #F06A6A/g' $POLYBAR_PATH/colors.ini
		sed -i -e 's/pink = .*/pink = #EC1850/g' $POLYBAR_PATH/colors.ini
		sed -i -e 's/purple = .*/purple = #BA40A0/g' $POLYBAR_PATH/colors.ini
		sed -i -e 's/blue = .*/blue = #427DCD/g' $POLYBAR_PATH/colors.ini
		sed -i -e 's/cyan = .*/cyan = #4DA8B9/g' $POLYBAR_PATH/colors.ini
		sed -i -e 's/teal = .*/teal = #008978/g' $POLYBAR_PATH/colors.ini
		sed -i -e 's/green = .*/green = #5CAC30/g' $POLYBAR_PATH/colors.ini
		sed -i -e 's/lime = .*/lime = #B9A41C/g' $POLYBAR_PATH/colors.ini
		sed -i -e 's/yellow = .*/yellow = #D2A91D/g' $POLYBAR_PATH/colors.ini
		sed -i -e 's/amber = .*/amber = #FD890F/g' $POLYBAR_PATH/colors.ini
		sed -i -e 's/orange = .*/orange = #EA7222/g' $POLYBAR_PATH/colors.ini
		sed -i -e 's/brown = .*/brown = #AC5C4E/g' $POLYBAR_PATH/colors.ini
		sed -i -e 's/indigo = .*/indigo = #4759C6/g' $POLYBAR_PATH/colors.ini
	
		sed -i -e 's/content = /content = /' $POLYBAR_PATH/user_modules.ini
		sed -i -e '323,325s/content-foreground = .*/content-foreground = #767676/' $POLYBAR_PATH/user_modules.ini
	
		## monochrome -------------------------
		sed -i -e 's/bg = .*/bg = #f2f2f2/g' $HOME/.config/polybar/mono/colors.ini
		sed -i -e 's/bg-alt = .*/bg-alt = #83B1B4/g' $HOME/.config/polybar/mono/colors.ini
		sed -i -e 's/fg = .*/fg = #222222/g' $HOME/.config/polybar/mono/colors.ini
		sed -i -e 's/fg-alt = .*/fg-alt = #B7B7B7/g' $HOME/.config/polybar/mono/colors.ini
	
		sed -i -e '452,456s/format-prefix-foreground = .*/format-prefix-foreground = ${color.purple}/' $HOME/.config/polybar/mono/modules.ini
	
		sed -i -e '323,326s/content-foreground = .*/content-foreground = ${color.blshade3}/' $HOME/.config/polybar/mono/user_modules.ini
	
	# relaunch polybar ------------------------
		polybar-msg cmd restart
	
	# rofi ------------------------------------
		sed -i -e '0,/shade1/s/shade1: .*/shade1: #f2f2f2F2;/g' $ROFI_COLORS_PATH
		sed -i -e '0,/shade2/s/shade2: .*/shade2: #93939399;/g' $ROFI_COLORS_PATH
		sed -i -e '0,/shade3/s/shade3: .*/shade3: #262425;/g' $ROFI_COLORS_PATH
		sed -i -e '0,/shade4/s/shade4: .*/shade4: #D7D7D7F2;/g' $ROFI_COLORS_PATH
	
	# st --------------------------------------
		sed -i -e '0,/background/s/*.background: .*/*.background:        #f2f2f2/g' $HOME/.Xresources
		sed -i -e '0,/foreground/s/*.foreground: .*/*.foreground:        #262425/g' $HOME/.Xresources
	
		xrdb -load $HOME/.Xresources
	fi
}

case $1 in
	-sw)
		switch
		;;
	-c)
		change
		;;
	-r)
		rofi -show run -theme $THEME
		;;
	-g)
		$HOME/scripts/global-rofi-menu.sh -g
		;;
	-s)
		$HOME/scripts/global-rofi-menu.sh -s
		;;
	-p)
		$HOME/scripts/global-rofi-menu.sh -p
		;;
	-m)
		$HOME/scripts/global-rofi-menu.sh -mc
		;;
	-w)
		rofi -show window -theme $THEME
		;;
esac