eval "$(/opt/homebrew/bin/brew shellenv)"

# Keep login-shell environment setup here so GUI apps can resolve it
# without depending on the full interactive shell stack.
export PATH="$PATH:/Users/josh/Library/Application Support/JetBrains/Toolbox/scripts"
export PATH="$PATH:/Users/josh/.local/bin"
export PATH="$PATH:/Users/josh/.dotnet/tools"

export PYENV_ROOT="$HOME/.pyenv"
if [[ -d "$PYENV_ROOT/bin" ]]; then
  export PATH="$PYENV_ROOT/bin:$PATH"
fi

if command -v pyenv >/dev/null 2>&1; then
  eval "$(pyenv init --path)"
fi
