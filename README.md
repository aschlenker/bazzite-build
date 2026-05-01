# Bazzite Build

Bazzite custom image with customizations for development and retro gaming.

## Changes

Added Fedora packages:

- android-tools
- bubblewrap
- dosbox-staging
- firejail
- flatpak-builder
- git-credential-libsecret
- git-subtree
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

After the installation, run:

```bash
sudo groupadd docker
sudo usermod -aG docker $USER
sudo usermod -aG libvirt $USER
sudo restorecon -rv /var/lib/libvirt
sudo restorecon -rv /var/log/libvirt
```

Layer `CDEmu` packages (optional):

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
