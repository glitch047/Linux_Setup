#!/usr/bin/env bash

# Basic Linux Setup Script
# This script installs and configures necessary packages, GNOME extensions, tools, and other utilities.

set -euo pipefail
IFS=$'\n\t'

#-----------------------------
# Variables & Lists
#-----------------------------

# Directories
PROGRAM_DIR="$HOME/ProgramFiles"
MOUNT_POINT="/media/100GB"

# Apt packages
APT_PACKAGES=(
  kali-linux-everything
  gimp
  vlc
  thunderbird
  libreoffice
  virtualbox
  mangohud
  cmake
  nload
  speedtest-cli
  kate
  cpu-x
  net-tools
  htop
  tree
  aptitude
  python3
  python3-pip
  wine64
  winbind
  playonlinux
  intel-gpu-tools
  netbird
  apparmor
  apparmor-utils
)

# Snap packages (classic where needed)
SNAP_PACKAGES=(
  "waveterm --classic"
  spotify
  "warp-terminal --classic"
  "teams-for-linux"
  standard-notes
  CanaryTokensDetector
  Logseq
  marktext
)

# .deb URLs (download and install)
DEB_URLS=(
  "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
  "https://discord.com/api/download?platform=linux&format=deb"
  "https://github.com/jgraph/drawio-desktop/releases/download/v20.4.0/drawio-amd64-20.4.0.deb"
  "https://packages.microsoft.com/repos/edge/pool/main/m/microsoft-edge-stable/microsoft-edge-stable_112.0.1722.58-1_amd64.deb"
  "https://repo.protonvpn.com/debian/dists/stable/main/binary-amd64/protonvpn-stable-release_1.0.0-1_all.deb"
  "https://repo.steampowered.com/steam/archive/steam_latest.deb"
  # SigPloit is a zip; treat it as downloadable too
  "https://github.com/Coalfire-Research/SigPloit/archive/refs/heads/master.zip"
)

# GNOME Extension UUIDs
GNOME_EXTENSIONS=(
  apps-menu@gnome-shell-extensions.gcampax.github.com
  burn-my-windows@gnome-shell-extensions.gcampax.github.com
  dash-to-dock@micxgx.gmail.com
  ding@rastersoft.com
  launch-new-instance@gnome-shell-extensions.gcampax.github.com
  media-controls@martin-prokop.gmail.com
  place-status-indicator@jayfrost.github.com
  quick-settings-audio-device-renamer@tim-count.github.com
  quick-settings-audio-panel@tim-count.github.com
  removable-drive-menu@gnome-shell-extensions.gcampax.github.com
  system-monitor@paradoxxx.zero.gmail.com
  tiling-scheme@valar.nsi.github.com
  user-themes@gnome-shell-extensions.gcampax.github.com
  ubuntu-appindicators@ubuntu.com
)

# Fstab entry
FSTAB_ENTRY="UUID=8C7C43127C42F68C /media/100GB ntfs defaults,uid=1000,gid=1000,dmask=022,fmask=133 0 0"

#-----------------------------
# Functions
#-----------------------------

echo_header() {
  echo -e "\n=== $1 ==="
}

install_apt_packages() {
  echo_header "Updating apt & installing packages"
  sudo apt update && sudo apt upgrade -y
  sudo apt install -y "\${APT_PACKAGES[@]}"
}

install_snap_packages() {
  echo_header "Installing snapd and snap packages"
  sudo apt install -y snapd
  sudo ln -sf /var/lib/snapd/snap /snap
  sudo systemctl enable --now snapd apparmor snapd.apparmor

  for pkg in "${SNAP_PACKAGES[@]}"; do
    sudo snap install $pkg || echo "Failed to install snap: $pkg"
  done
}

download_and_install_debs() {
  echo_header "Downloading and installing downloadable packages"
  mkdir -p "$PROGRAM_DIR"
  cd "$PROGRAM_DIR"

  for url in "${DEB_URLS[@]}"; do
    file=$(basename "$url" | sed 's/?.*//')
    echo "Fetching $url -> $PROGRAM_DIR/$file"
    wget -qO "$file" "$url"
    if [[ "$file" == *.deb ]]; then
      sudo dpkg -i "$file" || sudo apt-get install -f -y
    fi
    # leave zips or other downloaded files in ProgramFiles for manual install
  done
  cd - >/dev/null
}

setup_fstab() {
  echo_header "Configuring fstab"
  sudo mkdir -p "$MOUNT_POINT"
  grep -qxF "$FSTAB_ENTRY" /etc/fstab || \
    echo "$FSTAB_ENTRY" | sudo tee -a /etc/fstab
}

enable_gnome_extensions() {
  echo_header "Enabling GNOME Shell extensions"
  sudo apt install -y gnome-shell-extension-prefs gnome-shell-extension-manager
  for uuid in "${GNOME_EXTENSIONS[@]}"; do
    gnome-extensions install "$uuid" --force || echo "Ensure extension $uuid is available"
    gnome-extensions enable "$uuid" || echo "Failed to enable: $uuid"
  done
}

configure_user_shell() {
  echo_header "Configuring shell environment"
  for rc in ~/.bashrc ~/.zshrc; do
    grep -qxF 'export PATH=\$PATH:/snap/bin' "$rc" || \
      echo 'export PATH=$PATH:/snap/bin' >> "$rc"
  done
}

#-----------------------------
# Main
#-----------------------------

# Create program folder
mkdir -p "$PROGRAM_DIR"

install_apt_packages
install_snap_packages
download_and_install_debs
setup_fstab
enable_gnome_extensions
configure_user_shell

echo -e "\nSetup complete! Please reboot to apply all changes."
