# Bazzite Build

Bazzite custom image with customizations for development and retro gaming.

## Changes

Added packages:

- vscode
- docker

## Installation

For `bazzite`:

```bash
rpm-ostree rebase ostree-image-signed:docker://ghcr.io/aschlenker/bazzite:latest
```

After the installation update your user account:

```bash
sudo groupadd docker
sudo usermod -aG docker $USER
```
