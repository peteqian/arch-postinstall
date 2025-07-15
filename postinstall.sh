#!/bin/bash
set -e

# === System Update & Essentials ===
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm base-devel procps-ng curl file git

# === Homebrew & Oh My Posh ===
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

if ! command -v oh-my-posh &>/dev/null; then
  echo "Installing Oh My Posh..."
  brew install jandedobbeleer/oh-my-posh/oh-my-posh
fi

# Add Oh My Posh initialization to shell config
if [[ "$SHELL" == */bash ]]; then
  grep -qxF 'eval "$(oh-my-posh init bash)"' ~/.bashrc || echo 'eval "$(oh-my-posh init bash)"' >> ~/.bashrc
elif [[ "$SHELL" == */zsh ]]; then
  grep -qxF 'eval "$(oh-my-posh init zsh)"' ~/.zshrc || echo 'eval "$(oh-my-posh init zsh)"' >> ~/.zshrc
fi

# === Programming Languages ===
## Node.js via NVM
if [ ! -d "$HOME/.nvm" ]; then
  echo "Installing NVM..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi
nvm install --lts
nvm use --lts

## Python
sudo pacman -S --noconfirm python python-pip

## Go
sudo pacman -S --noconfirm go

## Rust
if ! command -v rustc &>/dev/null; then
  echo "Installing Rust..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source $HOME/.cargo/env
fi

# === Package Helpers & Utilities ===
## yay (AUR helper)
if ! command -v yay &>/dev/null; then
  echo "Installing yay..."
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  cd /tmp/yay
  makepkg -si --noconfirm
  cd -
  rm -rf /tmp/yay
fi

# === Development Tools & IDEs ===
## Visual Studio Code (AUR)
if ! command -v code &>/dev/null; then
  echo "Installing Visual Studio Code..."
  yay -S --noconfirm visual-studio-code-bin
fi

## Neovim
sudo pacman -S --noconfirm neovim

# Install LazyVim config for Neovim
LAZYVIM_DIR="$HOME/.config/nvim"
if [ ! -d "$LAZYVIM_DIR" ]; then
  echo "Installing LazyVim config..."
  git clone https://github.com/LazyVim/starter.git "$LAZYVIM_DIR"
fi

# Install Neovim dependencies after LazyVim
sudo pacman -S --noconfirm lazygit fzf ripgrep fd

# === Fonts ===
sudo pacman -S --noconfirm inter-font ttf-jetbrains-mono-nerd ttf-hack-nerd

# Install Monaco (AUR)
if ! fc-list | grep -i "Monaco" &>/dev/null; then
  yay -S --noconfirm ttf-monaco
fi

# === Browsers ===
yay -S --noconfirm google-chrome microsoft-edge-stable

# === Gaming ===
sudo pacman -S --noconfirm steam

echo "✅ Setup complete! Restart your terminal or source your shell config to apply changes."
