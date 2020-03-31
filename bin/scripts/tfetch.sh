#!/bin/sh

HOST=$(hostname)
OS=$(hostnamectl | awk '/Operating System/ {print $3}')
SHELL="$(basename "$SHELL")"
KERNEL=$(uname -sr)
UPTIME=$(uptime -p | sed -e 's/up //; s/ hours/h/; s/ hour/h/; s/ minutes/m/; s/ minute/m/; s/,//')
PACKAGES="$(pacman -Qq | wc -l)"
RESOLUTION="$(xrandr | awk '/*/ {print $1}')"
TERMINAL="$(xprop -id $WINDOWID WM_CLASS | cut -d" " -f3 | sed -e 's/^.\(.*\)..$/\1/; s/st-256color/st/')"
MEMORY="$(free -m | awk '/^Mem:/ {print $3 "M / " $2 "M"}')"

wm () {
    if [[ $DISPLAY && ! $WM ]]; then
        ID="$(xprop -root -notype _NET_SUPPORTING_WM_CHECK)"
        WM="$(xprop -id ${ID##* } -notype -len 100 -f _NET_WM_NAME 8t)"
        WM=${WM/*WM_NAME = } WM=${WM/\"} WM=${WM/\"*} WM=${WM,,}
        echo "${WM}"
    else
        echo "${WM:-tty$XDG_VTNR}"
    fi
}

# Colors

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

lc="${reset}${bold}${green}" # labels
nc="${reset}${bold}${blue}"  # user and hostname
r="${reset}"                 # reset
b="${bold}"                  # bold

# Output

cat <<EOF
${nc}$USER${r}@${nc}${HOST}${r}

${lc}os:     ${r}$OS${r}
${lc}up:     ${r}$UPTIME${r}
${lc}pkgs:   ${r}$PACKAGES${r}
${lc}sh:     ${r}$SHELL${r}
${lc}wm:     ${r}$(wm)${r}
${lc}term:   ${r}$TERMINAL${r}

EOF

#${red}▀▀${green}▀▀${yellow}▀▀${blue}▀▀${magenta}▀▀${cyan}▀▀${white}▀▀${r}