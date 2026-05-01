# Bazzite Build

Bazzite custom image with customizations for development and retro gaming.

## Changes

Added Fedora packages:

- dosbox-staging
- firejail
- git-credential-libsecret
- libvirt
- qemu-kvm
- virt-manager

Added Copr packages:

- cdemu-client ([rok/cdemu](https://copr.fedorainfracloud.org/coprs/rok/cdemu))
- cdemu-daemon ([rok/cdemu](https://copr.fedorainfracloud.org/coprs/rok/cdemu))
- faugus-launcher ([faugus/faugus-launcher](https://copr.fedorainfracloud.org/coprs/faugus/faugus-launcher/))

Added Vendor packages:

- Docker ([download.docker.com](https://download.docker.com/linux/fedora))
- VS Code ([packages.microsoft.com](https://packages.microsoft.com/yumrepos/vscode))

## Installation

For `bazzite`:

```bash
sudo bootc switch ghcr.io/aschlenker/bazzite:latest
```

After the installation update your user account:

```bash
sudo groupadd docker
sudo usermod -aG docker $USER
sudo groupadd libvirt
sudo usermod -aG libvirt $USER
```
