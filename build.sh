#!/bin/bash

set -ouex pipefail

fedora_pkgs=(
	android-tools
	bubblewrap
	dosbox-staging
	firejail
	git-credential-libsecret
	guestfs-tools
	libvirt
	libvirt-nss
	qemu
	sysprof
	virt-manager
	qemu-char-spice
	qemu-device-display-virtio-gpu
	qemu-device-display-virtio-vga
	qemu-device-usb-redirect
	qemu-img
	qemu-system-x86-core
	qemu-user-binfmt
	qemu-user-static
)
dnf --setopt=install_weak_deps=False install -y "${fedora_pkgs[@]}"

dnf config-manager addrepo --set=baseurl="https://packages.microsoft.com/yumrepos/vscode" --id="vscode"
dnf config-manager setopt vscode.enabled=0
dnf install --nogpgcheck --enable-repo="vscode" -y code

docker_pkgs=(
	containerd.io
	docker-buildx-plugin
	docker-ce
	docker-ce-cli
	docker-compose-plugin
	docker-model-plugin
)
dnf config-manager addrepo --from-repofile="https://download.docker.com/linux/fedora/docker-ce.repo"
dnf config-manager setopt docker-ce-stable.enabled=0
dnf install -y --enable-repo="docker-ce-stable" "${docker_pkgs[@]}"
systemctl enable docker.socket

dnf -y copr enable faugus/faugus-launcher
dnf -y install faugus-launcher
dnf -y copr disable faugus/faugus-launcher

dnf clean all

flatpak uninstall --delete-data org.kde.gwenview
flatpak uninstall --delete-data org.kde.okular
flatpak uninstall --delete-data org.kde.kcalc
flatpak uninstall --delete-data org.kde.haruna
flatpak uninstall --delete-data io.github.DenysMb.Kontainer
