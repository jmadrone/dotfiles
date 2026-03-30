if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi


# Added by Toolbox App
export PATH="$PATH:/Users/josh/Library/Application Support/JetBrains/Toolbox/scripts"


# Created by `pipx` on 2025-03-27 08:18:05
export PATH="$PATH:/Users/josh/.local/bin"
# Add .NET Core SDK tools
export PATH="$PATH:/Users/josh/.dotnet/tools"

# Minimal version-manager PATH for GUI-launched apps.
# Keep full interactive init in ~/.zshrc; only expose binaries/shims here.
export PYENV_ROOT="${PYENV_ROOT:-$HOME/.pyenv}"
[[ -d "$PYENV_ROOT/bin" ]] && export PATH="$PYENV_ROOT/bin:$PATH"
[[ -d "$PYENV_ROOT/shims" ]] && export PATH="$PYENV_ROOT/shims:$PATH"

export RBENV_ROOT="${RBENV_ROOT:-$HOME/.rbenv}"
[[ -d "$RBENV_ROOT/bin" ]] && export PATH="$RBENV_ROOT/bin:$PATH"
[[ -d "$RBENV_ROOT/shims" ]] && export PATH="$RBENV_ROOT/shims:$PATH"

export ASDF_DATA_DIR="${ASDF_DATA_DIR:-$HOME/.asdf}"
[[ -d "$ASDF_DATA_DIR/shims" ]] && export PATH="$ASDF_DATA_DIR/shims:$PATH"
