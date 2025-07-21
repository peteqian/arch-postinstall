#!/bin/bash

# Function to install via curl with error handling
install_with_curl() {
    local name=$1
    local url=$2
    local install_cmd=$3
    
    echo "🚀 Installing $name..."
    if ! eval "$install_cmd" &> /dev/null; then
        echo "❌ Failed to install $name"
        return 1
    fi
    echo "✅ $name installed successfully"
    return 0
}

# Homebrew
if ! command -v brew &>/dev/null; then
    install_with_curl \
        "Homebrew" \
        "https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh" \
        "/bin/bash -c \"\$(curl -fsSL $url)\" && eval \"\$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)\""
fi

# Oh My Posh
if ! command -v oh-my-posh &>/dev/null; then
    install_with_curl \
        "Oh My Posh" \
        "https://ohmyposh.dev/install.sh" \
        "curl -sSL $url | bash -s -- -b /usr/local/bin"
fi

# Add more curl installations below as needed
# Example:
# if ! command -v some-tool &>/dev/null; then
#     install_with_curl \
#         "Some Tool" \
#         "https://example.com/install.sh" \
#         "curl -sSL $url | bash"
# fi

echo "\n🎉 All curl-based installations completed!"
