# Bazzite Build

Bazzite custom image with customizations for development and retro gaming.

Differences to `bazzite-dx`:

- Based on `bazzite` not `bazzite-deck`

    Gets faster updates and allows for easy disabling of `Steam` autostart.

- Omission of unnecessary commandline tools

    These might be useful, but can easily be obtained with `homebrew`.

- Omission of `kvmfr`/`Looking Glass` configuration (for now)

    I simply did not find the time to tinker with it yet.

## Packages

Added Fedora packages:

- android-tools
- bubblewrap
- dosbox-staging
- firejail
- flatpak-builder
- git-credential-libsecret
- sysprof
- virt-manager
- rocm

Added Copr packages:

- faugus-launcher ([faugus/faugus-launcher](https://copr.fedorainfracloud.org/coprs/faugus/faugus-launcher/))

Added Vendor packages:

- docker ([download.docker.com](https://download.docker.com/linux/fedora))
- code ([packages.microsoft.com](https://packages.microsoft.com/yumrepos/vscode))

## Installation

### KDE Plasma

> [!TIP]
> If desktop entries don't show up in `KDE Plasma`'s `Application Launcher`, rebuild the desktop file system configuration cache by running `kbuildsycoca6`.

For `bazzite`:

```bash
sudo bootc switch ghcr.io/aschlenker/bazzite:latest
```

For `bazzite-nvidia-open`:

```bash
sudo bootc switch ghcr.io/aschlenker/bazzite-nvidia-open:latest
```

### GNOME

For `bazzite-gnome`:

```bash
sudo bootc switch ghcr.io/aschlenker/bazzite-gnome:latest
```

For `bazzite-gnome-nvidia-open`:

```bash
sudo bootc switch ghcr.io/aschlenker/bazzite-gnome-nvidia-open:latest
```

## Setup

Run these scripts after the installation to enable the corresponding features. A reboot is required for changes to take effect.

### Docker

> [!CAUTION]
> The docker group grants root-level privileges to the user. For details on how this impacts security in your system, see [Docker Daemon Attack Surface](https://docs.docker.com/engine/security/#docker-daemon-attack-surface).

```bash
sudo groupadd docker
sudo usermod -aG docker "${USER}"
```

### Virt Manager

> [!IMPORTANT]
> This script replaces `ujust setup-virtualization`.

```bash
sudo usermod -aG libvirt "${USER}"
if [[ ! -d /var/lib/swtpm-localca ]]; then
	sudo mkdir /var/lib/swtpm-localca
fi
sudo chown tss /var/lib/swtpm-localca
sudo restorecon -rv /var/lib/libvirt
sudo restorecon -rv /var/log/libvirt
```

## Optional

### CDEmu

This tool allows for the mounting of various disc image formats such as `bin/cue`. It could not be included in the image because it relies on a dynamically built kernel module.

> [!IMPORTANT]
> The required kernel module can only be loaded on `Bazzite` if `secure boot` is turned `off`, check your secure boot status with `mokutil --sb-state`.

```bash
sudo dnf -y copr enable rok/cdemu
rpm-ostree install cdemu-daemon
rpm-ostree install cdemu-client
```

## Development

### Format

```bash
shfmt -l -w build.sh
npx prettier --write README.md
```

### Check

```bash
shellcheck -x -s bash -o all build.sh
```
