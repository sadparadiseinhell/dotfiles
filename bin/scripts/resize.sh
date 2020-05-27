#!/bin/sh
wmctrl -r :ACTIVE: -e "$(slop -f 0,%x,%y,%w,%h)"
