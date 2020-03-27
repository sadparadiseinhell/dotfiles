#!/bin/bash
#
# Source: https://tools.suckless.org/dmenu/scripts/todo
#

FILE="$HOME/.todo.txt"
touch "$FILE"
HEIGHT=$(wc -l "$FILE" | awk '{print $1}')
PROMPT='add/delete: '
SOUND='/usr/share/sounds/freedesktop/stereo/dialog-information.oga'

CMD=$(dmenu -l "$HEIGHT" -p "$PROMPT" "$@" < "$FILE")
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

	CMD=$(dmenu -l "$HEIGHT" -p "$PROMPT" "$@" < "$FILE")
done
exit 0