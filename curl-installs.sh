#!/bin/bash

# Function to install via curl with error handling
install_with_curl() {
  local name=$1
  local install_cmd=$2

  echo "🚀 Installing $name..."
  if eval "$install_cmd"; then
    echo "✅ $name installed successfully"
    return 0
  else
    echo "❌ Failed to install $name"
    return 1
  fi
}

# Homebrew
if ! command -v brew &>/dev/null; then
  install_with_curl \
    "Homebrew" \
    '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"'
else
  echo "✅ Homebrew already installed"
fi

# Oh My Posh
if ! command -v oh-my-posh &>/dev/null; then
  install_with_curl \
    "Oh My Posh" \
    "curl -s https://ohmyposh.dev/install.sh | bash -s"
else
  echo "✅ Oh My Posh already installed"
fi

# NVM (Node Version Manager)
if [ ! -d "$HOME/.nvm" ]; then
  install_with_curl \
    "NVM" \
    'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash'

  # Source NVM to make it available in current session
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

  # Install latest LTS Node.js
  if command -v nvm &>/dev/null; then
    echo "🚀 Installing Node.js LTS via NVM..."
    nvm install --lts
    nvm use --lts
    echo "✅ Node.js LTS installed successfully"
  fi
else
  echo "✅ NVM already installed"
fi

# Rust
if ! command -v rustc &>/dev/null; then
  install_with_curl \
    "Rust" \
    'curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y'

  # Source cargo env to make it available in current session
  if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
  fi
else
  echo "✅ Rust already installed"
fi

# Bun (JavaScript runtime and package manager)
if ! command -v bun &>/dev/null; then
  install_with_curl \
    "Bun" \
    "curl -fsSL https://bun.sh/install | bash"

  # Add bun to current session PATH
  if [ -f "$HOME/.bun/bin/bun" ]; then
    export PATH="$HOME/.bun/bin:$PATH"
  fi
else
  echo "✅ Bun already installed"
fi

# Deno (JavaScript/TypeScript runtime)
if ! command -v deno &>/dev/null; then
  install_with_curl \
    "Deno" \
    "curl -fsSL https://deno.land/install.sh | sh"

  # Add deno to current session PATH
  if [ -f "$HOME/.deno/bin/deno" ]; then
    export PATH="$HOME/.deno/bin:$PATH"
  fi
else
  echo "✅ Deno already installed"
fi

# Starship prompt (alternative to Oh My Posh)
if ! command -v starship &>/dev/null; then
  install_with_curl \
    "Starship" \
    "curl -sSL https://starship.rs/install.sh | sh -s -- -y"
  els
  echo "✅ Starship already installed"
fi

echo ""
echo "🎉 All curl-based installations completed!"
echo ""
echo "Note: You may need to restart your shell or run 'source ~/.bashrc' (or ~/.zshrc)"
echo "to use newly installed tools like NVM, Rust, etc."
