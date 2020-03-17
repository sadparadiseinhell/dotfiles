#!/bin/bash

host=$(hostname)
os=$(hostnamectl | awk '/Operating System/ {print $3}')
shell="$(basename "$SHELL")"
kernel=$(uname -sr)
uptime=$(uptime -p | sed -e 's/up //; s/ hours/h/; s/ hour/h/; s/ minutes/m/; s/ minute/m/; s/,//')
packages="$(pacman -Qq | wc -l)"
resolution="$(xrandr | awk '/*/ {print $1}')"

wm () {
    if [[ $DISPLAY && ! $WM ]]; then
        ID="$(xprop -root -notype _NET_SUPPORTING_WM_CHECK)"
        WM="$(xprop -id ${ID##* } -notype -len 100 -f _NET_WM_NAME 8t)"
        WM=${WM/*WM_NAME = } WM=${WM/\"} WM=${WM/\"*} WM=${WM,,}
        echo "${WM:-$FB}"
    else
        echo "${WM:-tty$XDG_VTNR}"
    fi
}

terminal="$(xprop -id $WINDOWID WM_CLASS | cut -d" " -f3 | sed -e 's/^.\(.*\)..$/\1/; s/st-256color/st/')"
memory="$(free -m | awk '/^Mem:/ {print $3 "M / " $2 "M"}')"


# COLORS

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

lc="${reset}${bold}${green}"        # labels
nc="${reset}${bold}${blue}"         # user and hostname
r="${reset}"                        # reset
b="${bold}"                         # bold


# OUTPUT

clear

cat <<EOF
${nc}${USER}${r}@${nc}${host}${r}

${lc}os:    ${r}${os}${r}
${lc}up:    ${r}${uptime}${r}
${lc}pkgs:  ${r}${packages}${r}
${lc}sh:    ${r}${shell}${r}
${lc}wm:    ${r}$(wm)${r}
${lc}term:  ${r}${terminal}${r}

${red}██${green}██${yellow}██${blue}██${magenta}██${cyan}██${white}██${r}

EOF