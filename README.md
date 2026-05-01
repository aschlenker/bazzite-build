# Bazzite Build

Bazzite custom image with customizations for development and retro gaming.

## Changes

Added Fedora packages:

- android-tools
- bubblewrap
- dosbox-staging
- firejail
- git-credential-libsecret
- sysprof
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

After the installation, update your user account:

```bash
sudo groupadd docker
sudo usermod -aG docker $USER
sudo usermod -aG libvirt $USER
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
