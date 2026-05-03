# Bazzite Build

Bazzite custom image with customizations for development and retro gaming.

Differences to `bazzite-dx`:

- Based on `bazzite` not `bazzite-deck`

    Gets faster updates and allows for easy disabling of `Steam` autostart in `System Settings`.

- Omission of unnecessary commandline tools

    These might be useful but can easily be obtained with `homebrew`.

- Omission of `ROCm` (for now)

    On the positive side that means `Intel` users find `mesa-libOpenCL` is still available.

- Omission of `kvmfr`/`Looking Glass` (for now)

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

Added Copr packages:

- faugus-launcher ([faugus/faugus-launcher](https://copr.fedorainfracloud.org/coprs/faugus/faugus-launcher/))

Added Vendor packages:

- docker ([download.docker.com](https://download.docker.com/linux/fedora))
- code ([packages.microsoft.com](https://packages.microsoft.com/yumrepos/vscode))

## Installation

For `bazzite`:

```bash
sudo bootc switch ghcr.io/aschlenker/bazzite:latest
```

For `bazzite-nvidia-open`:

```bash
sudo bootc switch ghcr.io/aschlenker/bazzite-nvidia-open:latest
```

> [!IMPORTANT]
> If desktop entries don't show up in `Application Launcher`, rebuild the desktop file system configuration cache by running `kbuildsycoca6`

## Setup

Run these scripts after the installation to enable the corresponding features.

### Docker

```bash
sudo groupadd docker
sudo usermod -aG docker "${USER}"
echo "Reboot to apply changes"
```

### Virt Manager

> [!CAUTION]
> This script replaces `ujust setup-virtualization`

```bash
sudo usermod -aG libvirt "${USER}"
if [[ ! -d /var/lib/swtpm-localca ]]; then
	sudo mkdir /var/lib/swtpm-localca
fi
sudo chown tss /var/lib/swtpm-localca
sudo restorecon -rv /var/lib/libvirt
sudo restorecon -rv /var/log/libvirt
echo "Reboot to apply changes"
```

## Optional

### CDEmu

This tool allows for the mounting of various disc image formats such as `bin/cue`. It could not be included in the image because it relies on a dynamically built kernel module.

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
