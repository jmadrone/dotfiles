# Josh's Shell Aliases - June 2024

# Enable aliases to be sudo’ed
alias sudo='sudo '

# Generate a random password using UPPERCASE characters
alias GENPWDU="LC_ALL=C tr -dc '[:upper:]' < /dev/urandom | fold -w 20 | head -n1"

# Generate a random 24 character password using GnuPG
alias genpwd="gpg --gen-random --armor 0 24"

# Eject All Mountable Volumes
alias ea="osascript -e 'tell application "Finder" to eject (every disk whose ejectable is true)'"

# Flush DNS Cache
alias flushdns="sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder; echo DNS Cache was cleared successfully"

# Alias for Easy Data Transform
alias edt='/Applications/EasyDataTransform.app/Contents/MacOS/EasyDataTransform'

# Alias for Carbon Copy Cloner (CCC) Command Line Tool
alias ccc="/Applications/Carbon\ Copy\ Cloner.app/Contents/MacOS/ccc"

# Screamingfrog SEO Spider CLI
alias spider="/Applications/Screaming\ Frog\ SEO\ Spider.app/Contents/MacOS/ScreamingFrogSEOSpiderLauncher"

# PlistBuddy alias, because sometimes `defaults` just doesn’t cut it
alias plistbuddy="/usr/libexec/PlistBuddy"

# SoftRAID CLI Tool alias
alias srt="softraidtool"

# List all files colorized in long format, excluding . and ..
alias la="ls -lAF ${colorflag}"
# Airport CLI alias
alias airport='/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport'

# Nmap aliases
alias nmapp="nmap -Pn -A --osscan-limit"

# Show/hide hidden files in Finder
alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

# Trim new lines and copy to clipboard
#alias c="tr -d '\n' | pbcopy"

# Recursively delete `.DS_Store` files
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"

# Empty the Trash on all mounted volumes and the main HDD.
# Also, clear Apple’s System Logs to improve shell startup speed.
# Finally, clear download history from quarantine. https://mths.be/bum
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl; sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'"

# macOS has no `md5sum`, so use `md5` as a fallback
command -v md5sum >/dev/null || alias md5sum="md5"

# macOS has no `sha1sum`, so use `shasum` as a fallback
command -v sha1sum >/dev/null || alias sha1sum="shasum"

# IP addresses
#alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# Show active network interfaces
alias ifactive="ifconfig | pcregrep -M -o '^[^\t:]+:([^\n]|\n\t)*status: active'"

# Detect which `ls` flavor is in use
if ls --color >/dev/null 2>&1; then # GNU `ls`
  colorflag="--color"
  export LS_COLORS='no=00:fi=00:di=01;31:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'
else # macOS `ls`
  colorflag="-G"
  export LSCOLORS='BxBxhxDxfxhxhxhxhxcxcx'
fi

# Always use color output for `ls`
alias ls="command ls ${colorflag}"

#alias ls="ls -G --color"
alias lsf="ls -lahF"
alias la="ls -lahF ${colorflag}"
alias ll="ls -lhF ${colorflag}"

# List all files colorized in long format
alias l="ls -lF ${colorflag}"

# List all files colorized in long format, excluding . and ..
alias lsa="ls -lAF ${colorflag}"

# List only directories
alias lsd="ls -lF ${colorflag} | grep --color=never '^d'"

alias -g H="| head"
alias -g L="| less"
alias -g S="| sort"
alias -g T="| tail"
alias -g V="| vim -"
alias -g XC="| xclip -i"
alias -g XP="| xclip -o"

# Running tail a log file etc.
alias t="tail -f"

# Make new directory
alias md="mkdir -p"

# Shortcuts as aliases to jump to directories
alias drop="cd ~/Dropbox"
alias dropdocs="cd ~/Dropbox/Documents"
alias dl="cd ~/Downloads"
alias dt="cd ~/Desktop"
alias p="cd ~/Projects"
alias dropdev="cd ~/Dropbox/Developer"
alias dev="cd ~/Developer"
alias emsec="cd ~/Dropbox/Business/emerald-security"
alias clients="cd ~/Dropbox/Business/clients"

# Git shortcut
alias g="git"

# File operations
#alias cp="cp -i"
#alias mv="mv -i"
#alias rm="rm -i"

# Grep aliases
alias grpe='grep'
alias egrep='egrep --color=auto'
alias dfc='df -hPT | column -t'
alias grep='grep --color=auto'

# Show tree output in columns by default
alias tree='tree -C'

# Show current time in UTC time zone
alias utc='TZ=UTC date'

# Alias vi to vim
alias vi='vim'

# Aliases for working with Drafts for Mac
alias a2d '$HOME/Developer/scripts/drafts\ shell\ scripts/src/appendtodraft.sh'
alias opd '$HOME/Developer/scripts/drafts\ shell\ scripts/src/opendraft.sh'
alias p2d '$HOME/Developer/scripts/drafts\ shell\ scripts/src/prependtodraft.sh'
alias rda '$HOME/Developer/scripts/drafts\ shell\ scripts/src/rundraftsaction.sh'
alias 2d '$HOME/Developer/scripts/drafts\ shell\ scripts/src/todraft.sh'
alias 2df '$HOME/Developer/scripts/drafts\ shell\ scripts/src/todraftflagged.sh'

# Use atop instead of top
alias top='atop'

# set wget to resume downloads
alias wget='wget -c'

# become root #
alias root='sudo -i'
alias su='sudo -i'

# quickly list all ports on server
alias ports='netstat -tulanp'

# Stop after sending count ECHO_REQUEST packets #
#alias ping='ping -c 5'

# Do not wait interval 1 second, go fast #
alias fastping='ping -c 100 -s.2'

# For continuous ping before setting count use
#alias cping='/sbin/ping'

# make mount show in pretty and human readable
alias mount='mount | column -t'

# Clear screen
alias c='clear'

# set timezone to my local timezone
alias setlocaltime='TZ=US/Pacific'
