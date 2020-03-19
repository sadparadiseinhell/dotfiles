# Folders
alias home="cd $HOME"
alias config="cd $HOME/.config/"
alias downloads="cd $HOME/Downloads/"
alias music="cd $HOME/music/"
alias images="cd $HOME/wallpapers/"
alias dotfiles="cd $HOME/dotfiles/"

# Files
alias ls="ls --color=auto"

# Pacman
alias install="sudo pacman -S"
alias update="sudo pacman -Syu"
alias sp="sudo pacman"

# Xresources
alias xconf="vim $HOME/.Xresources"
alias xreload="xrdb -load $HOME/.Xresources"

# GitHub
alias push="$HOME/scripts/push.sh"
alias git-push="cd $HOME/dotfiles/; git add -A; git commit -m 'minor changes'; git push; home"
alias ga="git add"

# Media
alias watch='mpv --ytdl-format="bestvideo[ext=mp4][height<=?1080]+bestaudio[ext=m4a]" $1'
alias start-media-server="minidlnad"
alias stop-media-server="pkill minidlnad"

# Colors
alias changecolorscheme="$HOME/scripts/changecs.sh"
alias setwallpaper="$HOME/scripts/setwall.sh"

# Scripts
alias info="$HOME/scripts/tfetch.sh"
alias lock="$HOME/scripts/lock.sh"
alias power-menu="$HOME/scripts/power-menu.sh"
alias scrot-menu="$HOME/scripts/screenshot-menu.sh"

# Rebuild
alias dwm-rebuild="cd $HOME/build/dwm; make; make clean install; home"
alias st-rebuild="cd $HOME/build/st; make; make clean install; home"
alias slock-rebuild="cd $HOME/build/slock; make; sudo make clean install; home"
alias dmenu-rebuild="cd $HOME/build/dmenu; make; make clean install; home"
alias tabbed-rebuild="cd $HOME/build/tabbed; make; make clean install; home"
