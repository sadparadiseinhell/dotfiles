#!/bin/sh

sleep 15

get_total_updates() {
    UPDATES=$(checkupdates 2>/dev/null | wc -l);
}

while true; do
    get_total_updates

    if hash notify-send &>/dev/null; then
        if (( UPDATES > 50 )); then
            notify-send -u critical \
            "you really need to update!" "$UPDATES new packages"
        elif (( UPDATES > 25 )); then
            notify-send -u normal \
            "you should update soon" "$UPDATES new packages"
        elif (( UPDATES > 2 )); then
            notify-send -u low \
            "$UPDATES new packages"
        fi
    fi

    while (( UPDATES > 0 )); do
        if (( UPDATES == 1 )); then
            echo "$UPDATES update"
        elif (( UPDATES > 1 )); then
            echo "$UPDATES updates"
        fi
        sleep 10
        get_total_updates
    done

    while (( UPDATES == 0 )); do
        sleep 1800
        get_total_updates
    done
done
