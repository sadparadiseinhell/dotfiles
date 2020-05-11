#!/bin/sh

rofi_command="rofi -theme mpd.rasi"

# Gets the current status of mpd (for us to parse it later on)
status="$(mpc status)"
# Defines the Play / Pause option content
if [[ $status == *"[playing]"* ]]; then
    play_pause=""
else
    play_pause=""
fi
active=""
urgent=""

# Display if repeat mode is on / off
tog_repeat=""
if [[ $status == *"repeat: on"* ]]; then
    active="-a 3"
elif [[ $status == *"repeat: off"* ]]; then
    urgent="-u 3"
else
    tog_repeat=" Parsing error"
fi

# Display if random mode is on / off
tog_random=""
if [[ $status == *"random: on"* ]]; then
    [ -n "$active" ] && active+=",4" || active="-a 4"
elif [[ $status == *"random: off"* ]]; then
    [ -n "$urgent" ] && urgent+=",4" || urgent="-u 4"
else
    tog_random=" Parsing error"
fi
stop=""
next=""
previous=""

# Variable passed to rofi
options="$previous\n$play_pause\n$next\n$tog_repeat\n$tog_random"

# Get the current playing song
NUM=$(mpc -f %title% current | wc -c)
if [[ $NUM -ge '25' ]]; then
    current=$(echo $(mpc -f %title% current | cut -c -25)...)
elif [[ -z "$(mpc -f %title% current)" ]]; then
    current="-"
else
    current=$(mpc -f %title% current)
fi

# Spawn the mpd menu with the "Play / Pause" entry selected by default
chosen="$(echo -e "$options" | $rofi_command -p "$current" -dmenu $active $urgent -selected-row 1)"
case $chosen in
    $previous)
        mpc -q prev
        ;;
    $play_pause)
        $HOME/scripts/musicctrl.sh play
        ;;
    #$stop)
    #    mpc -q stop
    #    ;;
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
