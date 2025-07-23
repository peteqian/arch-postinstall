#!/bin/bash

set -e

BRIGHTNESS="${1:-50}"

# Install ddcutil if not installed
if ! command -v ddcutil &>/dev/null; then
  echo "📦 Installing ddcutil..."
  pacman -Sy --noconfirm ddcutil
fi

# Load required kernel modules - AMD
echo "🧩 Loading kernel modules..."
modprobe i2c-dev
modprobe i2c-piix4

# Persist kernel modules across reboots - AMD
echo "📥 Ensuring modules load on boot..."
sudo echo "i2c-dev" >/etc/modules-load.d/i2c-dev.conf
sudo echo "i2c-piix4" >/etc/modules-load.d/i2c-piix4.conf

# Detect monitor I2C bus
echo "🔍 Detecting external monitor..."
BUS=$(ddcutil detect | awk '/I2C bus:/ {print $3; exit}')

if [[ -z "$BUS" ]]; then
  echo "⚠️ No external monitor detected via DDC/CI."
  exit 1
fi

# Set brightness
echo "💡 Setting brightness to $BRIGHTNESS% on $BUS..."
ddcutil --bus="$BUS" setvcp 10 "$BRIGHTNESS"
echo "✅ Brightness set successfully."
