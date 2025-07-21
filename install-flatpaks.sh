FLATPAKS=(
  "spotify"
  "com.discordapp.Discord"
  "com.google.Chrome/x86_64/stable"
  "app.zen_browser.zen"
  "com.brave.Browser"
  "com.getpostman.Postman"
  "com.heroicgameslauncher.hgl"
  "com.obsproject.Studio"
  "md.obsidian.Obsidian"
  "org.blender.Blender"
  "com.stremio.Stremio"
  "rest.insomnia.Insomnia"
  "com.parsecgaming.parsec"
  "org.audacityteam.Audacity"
  "org.signal.Signal"
)

for pak in "${FLATPAKS[@]}"; do
  if ! flatpak list | grep -i "$pak" &> /dev/null; then
    echo "Installing Flatpak: $pak"
    flatpak install --noninteractive "$pak"
  else
    echo "Flatpak already installed: $pak"
  fi
done