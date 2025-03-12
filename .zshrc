# .zshrc - shell configuration file
# macOS M1 version for ARM processor

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


NOW="$(date +\%F-\%H:\%M:\%S)"
TODAY="$(date +\%F)"
TIMESTAMP="$(date '+%Y-%m-%d_%H%M%S')"

# Set default GPG key
KEYID=0xC4066D4674A6EBE7

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

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

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



################################### plugins ###################################
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
#  brew
#  bgnotify
#  bundler
  colorize
#  common-aliases
  colored-man-pages
#  copyfile
  copypath
#  dash
  dotenv
#  dotnet
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
#fpath=( ~$ZSH_CUSTOM/plugins/mac-zsh-completions/mac-zsh-completions/completions $fpath )

# Setup osx-zsh-completions manually installed in $ZSH_CUSTOM/plugins
fpath=( ~$ZSH_CUSTOM/plugins/osx-zsh-completions $fpath )

# Setup zsh-autocomplete installed with Homebrew
source /opt/homebrew/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh

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
zstyle :omz:plugins:ssh-agent agent-forwarding yes
zstyle :omz:plugins:ssh-agent identities ~/.config/ssh/{id_ed25519.pub,jm_id_ed25519.pub,rsync_id_rsa,id_ed25519_openpgp.pub}
# which can be simplified to
#zstyle :omz:plugins:ssh-agent identities ~/.ssh/{id_ed25519_sk_5716,id_ed25519_sk_7061}
# Use macOS Keychain to store passphrases for use when loading keys into agent
zstyle :omz:plugins:ssh-agent ssh-add-args --apple-load-keychain

# Configure alias-finder plugin
zstyle ':omz:plugins:alias-finder' autoload yes # disabled by default
# zstyle ':omz:plugins:alias-finder' longer yes # disabled by default
# zstyle ':omz:plugins:alias-finder' exact yes # disabled by default
# zstyle ':omz:plugins:alias-finder' cheaper yes # disabled by default

# Completions configuration
# workaround for "do you wish to see all x possibilities" prompt eating input
zstyle ':completion:*' menu select=long

# Use cache for commands which use it

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

# ZSH Colorize configuration
ZSH_COLORIZE_TOOL=chroma
ZSH_COLORIZE_CHROMA_FORMATTER=terminal256
ZSH_COLORIZE_STYLE="solarized-dark256"

# Custom configuration for zsh_autocomplete
#zstyle ':autocomplete:*' min-input 2

# Homebrew settings
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_INSECURE_REDIRECT=1

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nano'
else
  export EDITOR='code -n -w'
fi

# Set OpenAI API Key
export ZSH_ASK_API_KEY="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"

# GnuPG Settings are now in `${ZSH_CUSTOM}/gnupg.zsh`
export GPG_TTY=$TTY


# 1Password - Setup CLI Completions, SSH Agent, and Shell Plugins
# 1Password CLI Completions
eval "$(op completion zsh)"
compdef _op op

# 1Password SSH Agent
#export SSH_AUTH_SOCK="~/.1password/agent.sock"
#export SSH_AUTH_SOCK='~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock'

# 1Password Plugins
source /Users/josh/.config/op/plugins.sh

# Enable aws-cli auto-complete
AWS_CLI_AUTO_PROMPT=on

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
alias aliasconfig="code -n ${ZSH_CUSTOM/aliases.zsh}"
alias awsconfig="code -n ~/.aws/"
alias azureconfig="code -n ~/.azure/"


# GoCardless Alias to overwrite the default
alias gc='gocardless '


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

export PATH=""
path "/opt/homebrew/bin"
path "/opt/homebrew/sbin"
path "/usr/local/sbin"
path "/usr/local/bin"
#path "/usr/local/MacGPG2/bin" #GPG Tools for Mac path to the binaries
path "/usr/sbin"
path "/usr/bin"
path "/sbin"
path "/bin"
path "/Users/josh/bin"
#path "/Users/josh/.scripts"
#path "/opt/homebrew/opt/python@3.10/bin"
path "/Applications/MacVim.app/Contents/bin"
path "$HOME/.jenv/bin"

############################### set variables #################################

# Use Homebrew's OpenSSH
#export PATH=1/bin:$PATH

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

# Manage multiple ruby versions with `rbenv`
if command -v rbenv 1>/dev/null 2>&1; then
  eval "$(rbenv init - zsh)"
fi

# Homebrew GitHub API Token
export HOMEBREW_GITHUB_API_TOKEN=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



# Apple Developer Xcode Command Line Tools SDK
export SDKROOT=$(xcrun --show-sdk-path)



# Source `acme.sh` config to manage Free SSL Certificates from Lets Encrypt or ZeroSSL
source "/Users/josh/.acme.sh/acme.sh.env"

# Rclone_jobber shortcut
export rclone_jobber="/Users/josh/Developer/rclone_jobber"

# Set AWS_PROFILE to persist across terminal sessions
AWS_PROFILE_STATE_ENABLED=true


####################### manually installed zsh plugins ########################

# Uncomment the following line to permanently Setup iTerm2 Shell Integration (instead of using "Autom Setup checkbox")
#test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# To customize prompt, run `p10k configure` or edit `~/.p10k.zsh`.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Configure `fzf` fuzzy search
#[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source <(fzf --zsh)

# Source Homebrew installed zsh-autosuggestions per instructions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Source Homebrew installed zsh-sntax-highlighting per instructions
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
eval

# Zapier autocomplete setup
ZAPIER_AC_ZSH_SETUP_PATH=/Users/josh/Library/Caches/zapier/autocomplete/zsh_setup && test -f $ZAPIER_AC_ZSH_SETUP_PATH && source $ZAPIER_AC_ZSH_SETUP_PATH; # zapier autocomplete setup
