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

lc="${reset}${bold}${blue}"
nc="${reset}${bold}${red}"
r="${reset}"
b="${bold}"
p="${bold}${blue}"
pb="${bold}${yellow}"

output () {
#${red}▀▀${green}▀▀${yellow}▀▀${blue}▀▀${magenta}▀▀${cyan}▀▀${white}▀▀${r}
cat <<EOF

${p}    .--.      ${nc}$USER${r}@${nc}${HOST}${r}
${p}   /${r}o${pb}_${r}o${p} |     ${lc}os:    ${r}$OS${r}
${p}   |${pb}:_/${p} |     ${lc}up:    ${r}$UPTIME${r}
${p}  //   \ \    ${lc}pkgs:  ${r}$PACKAGES${r}
${p} (|     | )   ${lc}sh:    ${r}$SHELL${r}
${p}/'\_   _/'\   ${lc}wm:    ${r}$(wm)${r}
${p}\___)${r}=${p}(___/   ${lc}term:  ${r}$TERMINAL${r}

EOF
}

case $1 in
	-s)
	output; sleep .5; maim -u scrot.png &
		;;
	*)
	output
		;;
esac
