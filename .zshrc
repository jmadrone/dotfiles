# .zshrc - shell configuration file
# macOS M1 version for ARM processor

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# First, evaluate the username outside the if statement
USERNAME=$(print -P "%n")

# Use the evaluated variable in the path
CACHE_FILE="${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${USERNAME}.zsh"

# Check if the file is readable
if [[ -r "$CACHE_FILE" ]]; then
  source "$CACHE_FILE"
fi

# Source secrets file
if [ -f ~/.zsh_secrets ]; then
  source ~/.zsh_secrets
fi

NOW="$(date +\%F-\%H:\%M:\%S)"
TODAY="$(date +\%F)"
TIMESTAMP="$(date '+%Y-%m-%d_%H%M%S')"

# New GPG key for josh@emeraldsecurity.net
KEYID=0xA850B6F02A9E45DE

export CLICOLOR=1

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"


ZSH_THEME="powerlevel10k/powerlevel10k"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled # disable automatic updates
zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time
# update manually with: omz update

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

################################## plugins ###################################
# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# Commented plugins require manual install
# https://github.com/unixorn/awesome-zsh-plugins#plugins
plugins=(
  1password
#  aliases
  alias-finder
  aws
  azure
  brew
#  bgnotify
#  bundler
  colorize
#  common-aliases
  colored-man-pages
#  copyfile
  copypath
#  dash
  dotenv
  dotnet
  encode64
  gpg-agent
  ssh-agent
#  fzf
  genpass
  github
#  gitfast
  gitignore
  gh
#  git
#  last-working-dir
  macos
  mac-zsh-completions
#  osx-zsh-completions-1.0
  nmap
  gnu-utils
#  rsync
#  marked2
  sudo
#  supervisor
  vscode
#  wp-cli
  zsh-ask
#  zsh-autosuggestions
#  zsh-autocomplete #installed with Homebrew and sourced manually
#  zsh-completions #installed with Homebrew and added to fpath manually per instructions
#  zsh-syntax-highlighting #sourced manually per instuctions at end of .zshrc
 )

# The command to load `compinit` should come after modifying the `fpath` in
# your `.zshrc`, so modify fpath before sourcing ohmy-zsh.

# Setup zsh-completions with Oh-my-zsh!
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src

# Setup mac-zsh-completions
fpath=( "${ZSH_CUSTOM}/plugins/mac-zsh-completions/mac-zsh-completions/completions" $fpath )

# Setup osx-zsh-completions manually installed in $ZSH_CUSTOM/plugins
fpath=( "${ZSH_CUSTOM}/plugins/osx-zsh-completions" $fpath )

# Setup zsh-autocomplete installed with Homebrew
source /opt/homebrew/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# Add custom completions directory to fpath
fpath=( ~/oh-my-zsh/custom-completions $fpath )

# Setup completions to work with system zsh
#if ((!${fpath[(I) / opt / homebrew / share / zsh / site - functions]})); then
#  FPATH=/opt/homebrew/share/zsh/site-functions:$FPATH
#fi

# Setup Homebrew managed completions if using Oh-my-zsh!
FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

#autoload -Uz compinit && compinit
# Called by Oh-my-zsh to initialize completion system
# Therefore should not be called manually

# Source oh-my-zsh
# Update with `omz`
source $ZSH/oh-my-zsh.sh

############################## User configuration #############################

# Configure plugins with zstyle
# Note that the bulk of the configuration for ssh-agent plugin is in the README file for the plugin
zstyle :omz:plugins:ssh-agent quiet yes
zstyle :omz:plugins:ssh-agent lazy yes
#zstyle :omz:plugins:ssh-agent agent-forwarding yes
#zstyle :omz:plugins:ssh-agent identities ~/.config/ssh/{id_ed25519.pub,jm_id_ed25519.pub,rsync_id_rsa,id_ed25519_openpgp.pub}
# which can be simplified to
zstyle :omz:plugins:ssh-agent identities ~/.ssh/{id_ed25519_sk_rk_Yubikey6448,id_ed25519_sk_rk_Yubikey1555,id_ed25519_sk_5716,op_id_ed25519.pub,jm_id_ed25519.pub,op_id_rsa.pub}
# Use macOS Keychain to store passphrases for use when loading keys into agent
zstyle :omz:plugins:ssh-agent ssh-add-args --apple-load-keychain

# Configure alias-finder plugin
zstyle ':omz:plugins:alias-finder' autoload yes # disabled by default
# zstyle ':omz:plugins:alias-finder' longer yes # disabled by default
# zstyle ':omz:plugins:alias-finder' exact yes # disabled by default
# zstyle ':omz:plugins:alias-finder' cheaper yes # disabled by default

# Completions configuration
# workaround for "do you wish to see all x possibilities" prompt eating input
# Allow you to select in a menu
zstyle ':completion:*' menu select

# Autocomplete options for cd instead of directory stack
zstyle ':completion:*' complete-options true

zstyle ':completion:*' file-sort modification

zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:*:*:*:descriptions' format '%F{blue}-- %D %d --%f'
zstyle ':completion:*:*:*:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:*:*:*:warnings' format ' %F{red}-- no matches found --%f'
# zstyle ':completion:*:default' list-prompt '%S%M matches%s'
# Colors for files and directory
zstyle ':completion:*:*:*:*:default' list-colors ${(s.:.)LS_COLORS}

# Only display some tags for the command cd
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
# zstyle ':completion:*:complete:git:argument-1:' tag-order !aliases

# Required for completion to be in good groups (named after the tags)
zstyle ':completion:*' group-name ''

zstyle ':completion:*:*:-command-:*:*' group-order aliases builtins functions commands

# See ZSHCOMPWID "completion matching control"
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

zstyle ':completion:*' keep-prefix true

# Key bindings
bindkey '^H' backward-kill-word

#bindkey '\e[A' up-line-or-history
#bindkey '\e[B' down-line-or-history
# Use Bash style history search
bindkey '^[[1;5A' history-beginning-search-backward
bindkey '^[[1;5B' history-beginning-search-forward
# Use Arrow keys to search history
#bindkey '\e[A' history-beginning-search-backward
#bindkey '\e[B' history-beginning-search-forward


# ZSH Colorize configuration
ZSH_COLORIZE_TOOL=chroma
ZSH_COLORIZE_CHROMA_FORMATTER=terminal256
ZSH_COLORIZE_STYLE="solarized-dark256"

# Custom configuration for zsh_autocomplete
zstyle ':autocomplete:*' min-input 2

# Homebrew settings
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_INSECURE_REDIRECT=1

export HOMEBREW_GITHUB_API_TOKEN="op://Private/Homebrew Github API Token/Section_kisnbqsrqfhkygcuywhxkbab24/token"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nano'
else
  export EDITOR='code -n -w'
fi

# AWS CLI Configuration
# Enable aws-cli auto-complete
AWS_CLI_AUTO_PROMPT=on
# Set AWS_PROFILE to persist across terminal sessions
AWS_PROFILE_STATE_ENABLED=true

################################### aliases ###################################
# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the `ZSH_CUSTOM` folder.
# My `${ZSH_CUSTOM}` folder includes the following:
# - aliases.zsh
# - 1password.zsh
# - dotfiles.zsh
# - gnupg.zsh
# - yubikey.zsh
# - shortcuts.zsh
# - functions.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias zshconfig="code -n ~/.zshrc"
alias zshcustom="code -n ${ZSH_CUSTOM}"
alias ohmyzsh="code -n ~/.oh-my-zsh"
alias sshconfig="code -n ~/.ssh/config"
alias aliasconfig="code -n ${ZSH_CUSTOM}/aliases.zsh"
alias awsconfig="code -n ~/.aws/"
alias azureconfig="code -n ~/.azure/"


# Brewalias Alfred Workflow
alias brewalias='/usr/bin/osascript -e "tell application id \"com.runningwithcrayons.Alfred\" to run trigger \"build\" in workflow \"com.alfredapp.aliashomebrewapps\""'

# Homebrew maintenance alias
alias brewery="brew update && brew upgrade && brew cleanup"

############################### setup path ####################################
# PATH setup
function path() {
  if [[ -d "${1}" ]]; then
    if [[ -z "${PATH}" ]]; then
      export PATH="${1}"
    else
      export PATH="${PATH}:${1}"
    fi
  fi
}

#export PATH=""
path "/opt/homebrew/bin"
path "/opt/homebrew/sbin"
path "/usr/local/sbin"
path "/usr/local/bin"
# Added by GPG Suite
#path "/usr/local/MacGPG2/bin" #GPG Tools for Mac path to the binaries
path "/usr/sbin"
path "/usr/bin"
path "/sbin"
path "/bin"
# Added by Josh M (personal scripts and such)
path "/Users/josh/bin"
#path "/Users/josh/.scripts"
# Manually set Python version
#path "/opt/homebrew/opt/python@3.10/bin"
# Added by MacVim
path "/Applications/MacVim.app/Contents/bin"
# Added by jenv to manage multiple Java versions
path "$HOME/.jenv/bin"
# Added by Microsoft .NET SDK Tools
path "$HOME/.dotnet/tools"
# Added by pipx
path /Users/josh/.local/bin
# Use Homebrew's OpenSSH
#path /opt/homebrew/opt/openssh/bin

############################### set variables #################################


# Set Java version manually
# - liberica-jdk8-full is Java 8
# - microsoft-openjdk is modern Java 21

# Set JAVA_HOME variable to microsoft-openjdk cask
export JAVA_HOME=$(/usr/libexec/java_home -v 21)

# Set JAVA HOME variable for librica-jdk-8-full
#export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)


### MANAGE MULTIPLE VERSIONS WITH THESE TOOLS ###
# Setup `jenv` to manage Java versions
#export PATH=
#  eval "$(jenv init -)"

# Manage multiple Python versions with `pyenv`
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# Manage multiple Ruby versions with `rbenv`
if command -v rbenv 1>/dev/null 2>&1; then
  eval "$(rbenv init - zsh)"
fi


# Apple Developer Xcode Command Line Tools SDK
export SDKROOT=$(xcrun --show-sdk-path)


# Source `acme.sh` config to manage Free SSL Certificates from Lets Encrypt or ZeroSSL
source "/Users/josh/.acme.sh/acme.sh.env"

# Rclone_jobber shortcut
export rclone_jobber="/Users/josh/Developer/rclone_jobber"




####################### manually installed zsh plugins ########################

# Uncomment the following line to permanently Setup iTerm2 Shell Integration (instead of using "Autom Setup checkbox")
#test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# To customize prompt, run `p10k configure` or edit `~/.p10k.zsh`.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Configure `fzf` fuzzy search
if command -v fzf >/dev/null; then
  source <(fzf --zsh)
fi

# Source Homebrew installed zsh-autosuggestions per instructions
source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

# Source Homebrew installed zsh-syntax-highlighting per instructions
source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
eval
