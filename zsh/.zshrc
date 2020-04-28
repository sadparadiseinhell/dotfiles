# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/home/ma/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="simple"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
#plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Folders
alias home="cd $HOME"
alias config="cd $HOME/.config/"
alias downloads="cd $HOME/Downloads/"
alias music="cd $HOME/music/"
alias images="cd $HOME/wallpapers/"
alias dotfiles="cd $HOME/dotfiles/"
alias cd-='cd -'
alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias .....='cd ../../../../'

# Files
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias ls='ls --color=auto --group-directories-first'
alias ll='ls -lh --color=auto --group-directories-first'
alias la='ls -Ah --color=auto'
alias lla='ll -lAh'
alias cp='cp -v'
alias rm='rm -v'
alias mv='mv -v'

# Pacman
alias install='sudo pacman -S'
alias remove='sudo pacman -R'
alias update='sudo pacman -Syu'
alias sp='sudo pacman'

# System
alias pls='sudo'
alias ka='killall'

# Xresources
alias xconf="nvim $HOME/.Xresources"
alias xreload="xrdb -load $HOME/.Xresources"

# GitHub
alias gs='git status'
alias gl='git log'
alias ga='git add'
alias gaa='git add -A'
alias gal='git add .'
alias gall='git add .'
alias gca='git commit -a'
alias gc='git commit -m'
alias gcot='git checkout'
alias gchekout='git checkout'
alias go='git push -u origin'

# Media
alias watch='mpv --ytdl-format="bestvideo[ext=mp4][height<=?720]+bestaudio[ext=m4a]" $1'
alias start-minidlna="minidlnad -f /home/$USER/.config/minidlna/minidlna.conf -P /home/$USER/.config/minidlna/minidlna.pid"
alias stop-minidlna='killall minidlnad'

# Colors
alias setwallpaper="$HOME/scripts/setwall.sh"
alias colortest="$HOME/scripts/colortest.sh"

# Scripts
alias info="$HOME/scripts/tfetch.sh"
alias lock="$HOME/scripts/lock.sh"
alias power-menu="$HOME/scripts/power-menu.sh"
alias scrot-menu="$HOME/scripts/screenshot-menu.sh"

# Rebuild
alias dwm-rebuild="cd $HOME/build/dwm; make; sudo make clean install; home"
alias st-rebuild="cd $HOME/build/st; make; sudo make clean install; home"
alias slock-rebuild="cd $HOME/build/slock; make; sudo make clean install; home"
alias dmenu-rebuild="cd $HOME/build/dmenu; make; sudo make clean install; home"

# Games
alias minecraft="$HOME/.games/Minecraft_1.15.2/start.sh & exit"

# Other
alias ping='ping -c 5'
alias off='sleep 1; xset dpms force off'
alias vim='nvim'
alias subl='subl3'
alias todo='$HOME/scripts/bigtodo.sh'

# Shell
alias c='clear'
alias h='history'
alias :q='exit'
alias bye='exit'

# Info
alias cpuinfo='lscpu'
alias usage='du -ch | grep total'
alias totalusage='df -hl --total'
alias partusage='df -hlT --exclude-type=tmpfs --exclude-type=devtmpfs'
alias mostusage='du -hsx * | sort -rh | head -10'
alias now='date +%T'

man() {
    LESS_TERMCAP_md=$'\e[01;31m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;44;33m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;32m' \
    command man "$@"
}
