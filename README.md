# 🐧 Basic Linux Setup Script

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Build Status](https://img.shields.io/badge/status-stable-brightgreen)]()
[![Platform](https://img.shields.io/badge/platform-linux-blue)]()
[![Shell](https://img.shields.io/badge/shell-bash-lightgrey)]()

Automate my full Linux setup with one script — installs essential software, configures GNOME extensions, manages `.deb` and Snap installations, sets up drive mounting, and preps your development environment.

---

# 🐧 Basic Linux Setup Script

A complete bash script to automate setting up your Linux environment with essential tools, GNOME extensions, apps from APT, Snap, and `.deb` downloads, along with system configurations like fstab mounting and shell tweaks.

---

## 🚀 Features

* 📦 Installs a full suite of APT packages including development tools, multimedia apps, and utilities.
* 🛠 Configures GNOME with all your favorite extensions.
* 📥 Installs Snap packages and resolves setup steps for `snapd` and `apparmor`.
* 🌐 Downloads and installs `.deb` and zip tools into `~/ProgramFiles`.
* 📂 Automatically mounts a drive using a custom `/etc/fstab` entry.
* ⚙️ Configures shell profiles with updated `PATH`.

---

## 📁 Directory Structure

| Path              | Description                                                  |
| ----------------- | ------------------------------------------------------------ |
| `~/ProgramFiles/` | Stores all downloaded `.deb` files, zips, and other software |
| `/media/100GB`    | Mount point for your NTFS volume using UUID                  |

---

## 🧰 Installed Tools

### GNOME Extensions

* Apps Menu
* Burn My Windows
* Dash to Dock
* Desktop Icon NG (DING)
* Launch new instance
* Media Controls
* Place Status Indicator
* Quick Settings Audio Device Renamer
* Quick Settings Audio Panel
* Removable Drive Menu
* System Monitor
* Tiling Shell
* User Themes
* Ubuntu AppIndicator

### Snap Packages

* Waveterm (`--classic`)
* Spotify
* Warp Terminal (`--classic`)
* Teams for Linux
* Standard Notes
* CanaryTokensDetector
* Logseq
* Marktext

### APT Packages

Includes (but not limited to):

* `kali-linux-everything`
* `gimp`, `vlc`, `thunderbird`, `libreoffice`
* `virtualbox`, `mangohud`, `cmake`, `htop`, `tree`
* `python3`, `python3-pip`, `wine64`, `playonlinux`
* `net-tools`, `intel-gpu-tools`, `netbird`, `nload`

### DEB & Manual Downloads

Downloaded into `~/ProgramFiles/`:

* [Google Chrome](https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb)
* [Discord](https://discord.com/api/download?platform=linux&format=deb)
* [Draw.io](https://github.com/jgraph/drawio-desktop/releases)
* [Microsoft Edge](https://packages.microsoft.com/)
* [ProtonVPN](https://repo.protonvpn.com/)
* [Steam](https://store.steampowered.com/about/)
* [SigPloit](https://github.com/Coalfire-Research/SigPloit)

---

## ⚙️ Shell Configuration

Adds Snap path to:

* `~/.bashrc`
* `~/.zshrc`

```bash
export PATH=$PATH:/snap/bin
```

---

## 📂 FSTAB Mount

Appends the following to `/etc/fstab` (if not already added):

```bash
UUID=8C7C43127C42F68C /media/100GB ntfs defaults,uid=1000,gid=1000,dmask=022,fmask=133 0 0
```

---

## 🧪 Requirements

* Debian-based Linux distro (e.g., Ubuntu, Kali)
* Root privileges (script uses `sudo`)
* GNOME desktop environment

---

## ✅ Usage

```bash
chmod +x setup.sh
./setup.sh
```

Once finished, reboot your system to apply all changes:

```bash
sudo reboot
```

---

## 📌 Notes

* Some GNOME extensions may need manual installation from [extensions.gnome.org](https://extensions.gnome.org/).
* `.zip` packages (e.g., SigPloit) are downloaded but not automatically extracted or installed.
