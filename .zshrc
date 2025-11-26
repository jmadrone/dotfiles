################################################################################
# ~/.zshrc — Clean, Correct, Final Version
# macOS • iTerm2 • Powerlevel10k • zsh-autocomplete • SmartCard SSH agent
################################################################################

### ────────────────────────────────────────────────────────────────────────────
### 0. Powerlevel10k Instant Prompt (MUST STAY FIRST)
### ────────────────────────────────────────────────────────────────────────────

USERNAME=$(print -P "%n")
CACHE_FILE="${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${USERNAME}.zsh"
[[ -r "$CACHE_FILE" ]] && source "$CACHE_FILE"


### ────────────────────────────────────────────────────────────────────────────
### 1. Core Environment + Secrets
### ────────────────────────────────────────────────────────────────────────────

[[ -f ~/.zsh_secrets ]] && source ~/.zsh_secrets

export LANG=en_US.UTF-8
export CLICOLOR=1
export NOW="$(date +%F-%H:%M:%S)"
export TODAY="$(date +%F)"
export TIMESTAMP="$(date +%Y-%m-%d_%H%M%S)"


### ────────────────────────────────────────────────────────────────────────────
### 2. SSH Agent Detection (1Password / YubiKey / GPG / system)
### ────────────────────────────────────────────────────────────────────────────

detect_ssh_agent() {
  if [[ -z "$SSH_AUTH_SOCK" ]]; then
    SSH_AGENT_STATUS="none"
    return
  fi
  case "$SSH_AUTH_SOCK" in
    (*1password*|*agent.1p.ssh*)
      SSH_AGENT_STATUS="1password" ;;
    (*yubikey-agent*)
      SSH_AGENT_STATUS="yubikey-agent" ;;
    (*gpg-agent*|*gnupg*)
      SSH_AGENT_STATUS="gpg-agent" ;;
    (*)
      SSH_AGENT_STATUS="system" ;;
  esac
}
detect_ssh_agent

sshagent-info() {
  echo "SSH_AUTH_SOCK: $SSH_AUTH_SOCK"
  echo "Detected agent: $SSH_AGENT_STATUS"
}


### ────────────────────────────────────────────────────────────────────────────
### 3. Oh-My-Zsh Bootstrap (minimal plugin set)
### ────────────────────────────────────────────────────────────────────────────

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  1password
  alias-finder
  aws
  azure
  brew
  colorize
  copypath
  dotenv
  gh
  gnu-utils
  macos
  nmap
  ssh-agent
  sudo
  vscode
  zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh


### ────────────────────────────────────────────────────────────────────────────
### 4. Completion Engine (zsh-autocomplete — must load AFTER OMZ)
### ────────────────────────────────────────────────────────────────────────────

source /opt/homebrew/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# tuning
zstyle ':autocomplete:*' min-input 2


### ────────────────────────────────────────────────────────────────────────────
### 5. Key Bindings (Emacs mode)
### ────────────────────────────────────────────────────────────────────────────

bindkey -e   # Emacs editing mode

# Bash-style history search with Ctrl+Up / Ctrl+Down
bindkey '^[[1;5A' history-beginning-search-backward
bindkey '^[[1;5B' history-beginning-search-forward

# Tab / Shift-Tab completion menu cycling
bindkey '^I' menu-complete
bindkey "$terminfo[kcbt]" reverse-menu-complete

# History search shortcuts
bindkey -M emacs "^[p" .history-search-backward
bindkey -M emacs "^[n" .history-search-forward

bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward

# Autosuggestion accept/clear
bindkey '^[`' autosuggest-clear     # ESC-[ (your old mapping)
bindkey '^@' autosuggest-accept     # Ctrl-Space


### ────────────────────────────────────────────────────────────────────────────
### 6. PATH Management (deduped, safe)
### ────────────────────────────────────────────────────────────────────────────

# Safe PATH-add function
path() {
  local dir="$1"
  [[ -d "$dir" ]] || return
  case ":$PATH:" in
    *":$dir:"*) ;;            # already exists
    *) PATH="$PATH:$dir" ;;
  esac
}

# Base PATH entries
path "/opt/homebrew/bin"
path "/opt/homebrew/sbin"
path "/usr/local/bin"
path "/usr/local/sbin"
path "/usr/bin"
path "/usr/sbin"
path "/bin"
path "/sbin"
path "$HOME/bin"
path "/Applications/MacVim.app/Contents/bin"
path "$HOME/.jenv/bin"
path "$HOME/.dotnet/tools"
path "$HOME/.local/bin"


### ────────────────────────────────────────────────────────────────────────────
### 7. Toolchain Initialization
### ────────────────────────────────────────────────────────────────────────────

export JAVA_HOME=$(/usr/libexec/java_home -v 21)
command -v pyenv 1>/dev/null && eval "$(pyenv init -)"
command -v rbenv 1>/dev/null && eval "$(rbenv init - zsh)"
export SDKROOT=$(xcrun --show-sdk-path)


### ────────────────────────────────────────────────────────────────────────────
### 8. Tools + Environment
### ────────────────────────────────────────────────────────────────────────────

source "$HOME/.acme.sh/acme.sh.env"
export rclone_jobber="$HOME/Developer/rclone_jobber"

export AWS_CLI_AUTO_PROMPT=on
export AWS_PROFILE_STATE_ENABLED=true

export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_INSECURE_REDIRECT=1
export HOMEBREW_GITHUB_API_TOKEN="op://Private/Homebrew Github API Token/Section_kisnbqsrqfhkygcuywhxkbab24/token"


### ────────────────────────────────────────────────────────────────────────────
### 9. Syntax Highlighting (MUST BE LAST)
### ────────────────────────────────────────────────────────────────────────────

source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"


### ────────────────────────────────────────────────────────────────────────────
### 10. zsh-doctor (diagnostics only — NO FIXER)
### ────────────────────────────────────────────────────────────────────────────

zsh-doctor() {
  print -P "%F{blue}──────────────────────────────────────── ZSH DOCTOR ────────────────────────────────────────%f"

  print -P "%F{cyan}[1] Zsh Version:%f $(zsh --version)"
  print -P "%F{cyan}[2] Editing Mode:%f $KEYMAP"

  [[ "$KEYMAP" != emacs ]] && print -P "%F{yellow}  ⚠ Non-Emacs keymap detected.%f"

  if [[ -n "$ZSH_AUTOCOMPLETE_VERSION" ]]; then
    print -P "%F{green}[3] zsh-autocomplete active:%f $ZSH_AUTOCOMPLETE_VERSION"
  else
    print -P "%F{red}[3] zsh-autocomplete NOT active.%f"
  fi

  if typeset -f _zsh_autosuggest_start >/dev/null; then
    print -P "%F{green}[4] zsh-autosuggestions loaded.%f"
  else
    print -P "%F{red}[4] zsh-autosuggestions NOT loaded.%f"
  fi

  if typeset -f _zsh_highlight >/dev/null; then
    print -P "%F{green}[5] zsh-syntax-highlighting loaded.%f"
  else
    print -P "%F{red}[5] zsh-syntax-highlighting NOT loaded.%f"
  fi

  print -P "%F{cyan}[6] SSH Agent:%f"
  echo "    SSH_AUTH_SOCK: $SSH_AUTH_SOCK"
  echo "    Detected:      $SSH_AGENT_STATUS"

  print -P "%F{blue}──────────────────────────────────────── END ────────────────────────────────────────────%f"
}


### ────────────────────────────────────────────────────────────────────────────
### 11. Aliases
### ────────────────────────────────────────────────────────────────────────────

alias zshconfig="code -n ~/.zshrc"
alias zshcustom="code -n $ZSH_CUSTOM"
alias ohmyzsh="code -n ~/.oh-my-zsh"
alias sshconfig="code -n ~/.ssh/config"
alias aliasconfig="code -n $ZSH_CUSTOM/aliases.zsh"
alias awsconfig="code -n ~/.aws/"
alias azureconfig="code -n ~/.azure/"
alias brewalias='/usr/bin/osascript -e "tell application id \"com.runningwithcrayons.Alfred\" to run trigger \"build\" in workflow \"com.alfredapp.aliashomebrewapps\""'
alias brewery="brew update && brew upgrade && brew cleanup"


### ────────────────────────────────────────────────────────────────────────────
### 12. Powerlevel10k Prompt
### ────────────────────────────────────────────────────────────────────────────

[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
