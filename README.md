# Bazzite Build

Bazzite custom image with customizations for development and retro gaming.

## Changes

Added packages:

- vscode
- docker
- virt-manager

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
