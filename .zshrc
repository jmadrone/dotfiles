################################################################################
# ~/.zshrc — Clean, Correct, Final Version
# macOS • iTerm2 • Powerlevel10k • zsh-autocomplete • SmartCard SSH agent
################################################################################

### ────────────────────────────────────────────────────────────────────────────
### 0. Powerlevel10k Instant Prompt (MUST STAY FIRST)
### ────────────────────────────────────────────────────────────────────────────

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
(( ${+commands[direnv]} )) && emulate zsh -c "$(direnv export zsh)"

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

(( ${+commands[direnv]} )) && emulate zsh -c "$(direnv hook zsh)"

### ────────────────────────────────────────────────────────────────────────────
### 1. Core Environment + Secrets
### ────────────────────────────────────────────────────────────────────────────

[[ -f ~/.zsh_secrets ]] && source ~/.zsh_secrets

export LANG=en_US.UTF-8
export CLICOLOR=1

# NOW / TODAY / TIMESTAMP — updated before each command (preexec) and before each prompt (precmd)
refresh_time_vars() {
  export NOW="$(command date +%F-%H:%M:%S)"
  export TODAY="$(command date +%F)"
  export TIMESTAMP="$(command date +%Y-%m-%d_%H%M%S)"
}
refresh_time_vars


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
### 2.1 SSH Agent Switching (manual override)
### ────────────────────────────────────────────────────────────────────────────

# 1Password SSH agent socket (macOS default)
_ssh_sock_1password() {
  local sock="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
  [[ -S "$sock" ]] && echo "$sock"
}

# System ssh-agent socket (launchd-managed)
_ssh_sock_system() {
  launchctl getenv SSH_AUTH_SOCK 2>/dev/null
}

sshagent-use-1password() {
  local sock="$(_ssh_sock_1password)"

  if [[ -z "$sock" ]]; then
    echo "❌ 1Password SSH agent socket not found"
    return 1
  fi

  export SSH_AUTH_SOCK="$sock"
  detect_ssh_agent
  echo "✅ SSH agent set to: $SSH_AGENT_STATUS"
}

sshagent-use-system() {
  local sock="$(_ssh_sock_system)"

  if [[ -z "$sock" ]]; then
    echo "❌ System ssh-agent not available"
    return 1
  fi

  export SSH_AUTH_SOCK="$sock"
  detect_ssh_agent
  echo "✅ SSH agent set to: $SSH_AGENT_STATUS"
}

sshagent-disable() {
  unset SSH_AUTH_SOCK
  SSH_AGENT_STATUS="none"
  echo "🚫 SSH agent disabled"
}

### ────────────────────────────────────────────────────────────────────────────
### 3. Oh-My-Zsh Bootstrap (minimal plugin set)
### ────────────────────────────────────────────────────────────────────────────

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  alias-finder
  aws
  azure
  brew
  colorize
  copypath
  gh
  gnu-utils
  macos
  nmap
  sudo
  vscode
  zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

autoload -Uz add-zsh-hook
add-zsh-hook precmd refresh_time_vars
add-zsh-hook preexec refresh_time_vars


### ────────────────────────────────────────────────────────────────────────────
### 4. Completion Engine (zsh-autocomplete — must load AFTER OMZ)
### ────────────────────────────────────────────────────────────────────────────

_zsh_autocomplete=
[[ -f /opt/homebrew/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh ]] && _zsh_autocomplete=/opt/homebrew/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
[[ -z $_zsh_autocomplete && -f /usr/local/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh ]] && _zsh_autocomplete=/usr/local/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
[[ -n $_zsh_autocomplete ]] && source "$_zsh_autocomplete"
unset _zsh_autocomplete

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

# Append dir to PATH if missing (not named `path` — that shadows zsh's path/PATH tie)
path_add() {
  local dir="$1"
  [[ -d "$dir" ]] || return
  case ":$PATH:" in
    *":$dir:"*) ;;            # already exists
    *) PATH="$PATH:$dir" ;;
  esac
}

# Base PATH entries
path_add "/opt/homebrew/bin"
path_add "/opt/homebrew/sbin"
path_add "/usr/local/bin"
path_add "/usr/local/sbin"
path_add "/usr/bin"
path_add "/usr/sbin"
path_add "/bin"
path_add "/sbin"
path_add "$HOME/bin"
path_add "/Applications/MacVim.app/Contents/bin"
path_add "$HOME/.jenv/bin"
path_add "$HOME/.dotnet/tools"
path_add "$HOME/.local/bin"
path_add "${ASDF_DATA_DIR:-$HOME/.asdf}/shims"


### ────────────────────────────────────────────────────────────────────────────
### 7. Tools + Environment
### ────────────────────────────────────────────────────────────────────────────

# Homebrew binary (do not rely on PATH alone — helps GUI-spawned tools)
_brew_bin=
[[ -x /opt/homebrew/bin/brew ]] && _brew_bin=/opt/homebrew/bin/brew
[[ -z $_brew_bin && -x /usr/local/bin/brew ]] && _brew_bin=/usr/local/bin/brew

# ASDF (must load before any asdf-managed toolchains)
if [[ -n $_brew_bin ]]; then
  _asdf_sh="$($_brew_bin --prefix asdf 2>/dev/null)/libexec/asdf.sh"
  [[ -r $_asdf_sh ]] && . "$_asdf_sh"
  unset _asdf_sh
fi

# Java Home (prefer 21, else any default JDK)
if _jh=$(/usr/libexec/java_home -v 21 2>/dev/null); then
  export JAVA_HOME=$_jh
elif _jh=$(/usr/libexec/java_home 2>/dev/null); then
  export JAVA_HOME=$_jh
fi
unset _jh

# Python and Ruby Environments
# PATH/shims live in ~/.zprofile for GUI apps; full interactive init stays here.
command -v pyenv 1>/dev/null && eval "$(pyenv init -)"
command -v rbenv 1>/dev/null && eval "$(rbenv init - zsh)"

# SDKROOT
export SDKROOT=$(xcrun --show-sdk-path)

# acme.sh
[[ -f "$HOME/.acme.sh/acme.sh.env" ]] && source "$HOME/.acme.sh/acme.sh.env"

# Rclone Jobber setup
export rclone_jobber="$HOME/Developer/rclone_jobber"

# AWS CLI v2 auto-prompt and profile state
export AWS_CLI_AUTO_PROMPT=on
export AWS_PROFILE_STATE_ENABLED=true

# Homebrew environment variables
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_INSECURE_REDIRECT=1
# HOMEBREW_GITHUB_API_TOKEN lives in ~/.zsh_secrets (plain export — avoids `op read` / Touch ID on every shell)

# Citation Compliance Azure Subscriptions
export ANSI_PROD_SUBSCRIPTION_ID="39b730ee-923b-4984-8afd-6ae2cdf4a6ba"
export TEST_SUBSCRIPTION_ID="ce81da77-db96-4f42-a1a2-c78af55d9eac"
export HEMP_PROD_SUBSCRIPTION_ID="4590f2f9-6f9e-4402-99e3-fac008b34706"
export CEI_PROD_SUBSCRIPTION_ID="1e4358df-12a7-4b8a-930e-08fb7e9b348b"
export CITATION_PROD_SUBSCRIPTION_ID="5136e1e2-3a60-4205-9df6-4435fe4589be"

### ────────────────────────────────────────────────────────────────────────────
### 8. zsh-doctor (diagnostics only — NO FIXER)
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
### 9. Aliases
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
alias ssh1p='sshagent-use-1password'
alias sshsys='sshagent-use-system'
alias sshoff='sshagent-disable'
alias sshinfo='sshagent-info'


### ────────────────────────────────────────────────────────────────────────────
### 10. Powerlevel10k Prompt
### ────────────────────────────────────────────────────────────────────────────

[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh


### ────────────────────────────────────────────────────────────────────────────
### 11. Syntax highlighting (MUST BE LAST — after OMZ, autocomplete, and p10k)
### ────────────────────────────────────────────────────────────────────────────

_zsh_highlight=
[[ -n $_brew_bin ]] && _zsh_highlight="$($_brew_bin --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
[[ -z $_zsh_highlight || ! -f $_zsh_highlight ]] && _zsh_highlight=/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[[ ! -f $_zsh_highlight ]] && _zsh_highlight=/usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[[ -f $_zsh_highlight ]] && source "$_zsh_highlight"
unset _brew_bin _zsh_highlight
