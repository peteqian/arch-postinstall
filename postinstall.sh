.#!/bin/bash
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

# Add Oh My Posh to shell config
if [[ "$SHELL" == */bash ]]; then
  grep -qxF 'eval "$(oh-my-posh init bash)"' ~/.bashrc || echo 'eval "$(oh-my-posh init bash)"' >>~/.bashrc
elif [[ "$SHELL" == */zsh ]]; then
  grep -qxF 'eval "$(oh-my-posh init zsh)"' ~/.zshrc || echo 'eval "$(oh-my-posh init zsh)"' >>~/.zshrc
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

# === AUR Helper ===
if ! command -v yay &>/dev/null; then
  echo "Installing yay..."
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  cd /tmp/yay
  makepkg -si --noconfirm
  cd -
  rm -rf /tmp/yay
fi

# === IDEs & Editors ===
## VS Code (Microsoft official)
yay -S --noconfirm visual-studio-code-bin

## Neovim + LazyVim
sudo pacman -S --noconfirm neovim
if [ ! -d "$HOME/.config/nvim" ]; then
  git clone https://github.com/LazyVim/starter ~/.config/nvim
fi

# Post-LazyVim dependencies
sudo pacman -S --noconfirm lazygit fzf ripgrep fd

# === Fonts ===
sudo pacman -S --noconfirm inter-font ttf-jetbrains-mono-nerd ttf-hack-nerd noto-fonts noto-fonts-cjk ttf-nerd-fonts-symbols-mono
yay -S --noconfirm ttf-monaco

# === Browsers ===
yay -S --noconfirm google-chrome microsoft-edge-stable

# === Apps ===
sudo pacman -S --noconfirm discord docker steam kitty wofi waybar tff-font-awesome hyprland hyprshot swaync hyprlock hypridle stow hyprpaper
yay -S --noconfirm docker-desktop tradingview

# Docker setup
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker "$USER"

# Enable Docker Desktop
systemctl --user enable docker-desktop
systemctl --user start docker-desktop

# === Shell Enhancements ===
sudo pacman -S --noconfirm fish
echo "if command -v fish &>/dev/null; then exec fish; fi" >>~/.bashrc

echo "✅ Done! Reboot or logout/login for group changes and shell update to apply."
