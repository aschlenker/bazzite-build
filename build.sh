#!/bin/bash

set -ouex pipefail

fedora_pkgs=(
	dosbox-staging
	firejail
	git-credential-libsecret
	qemu-kvm
	libvirt
	virt-manager
)
dnf5 --setopt=install_weak_deps=False install -y "${fedora_pkgs[@]}"

dnf5 config-manager addrepo --set=baseurl="https://packages.microsoft.com/yumrepos/vscode" --id="vscode"
dnf5 config-manager setopt vscode.enabled=0
dnf5 install --nogpgcheck --enable-repo="vscode" -y code

docker_pkgs=(
    containerd.io
    docker-buildx-plugin
    docker-ce
    docker-ce-cli
    docker-compose-plugin
)
dnf5 config-manager addrepo --from-repofile="https://download.docker.com/linux/fedora/docker-ce.repo"
dnf5 config-manager setopt docker-ce-stable.enabled=0
dnf5 install -y --enable-repo="docker-ce-stable" "${docker_pkgs[@]}"
systemctl enable docker.socket

dnf5 -y copr enable rok/cdemu
dnf5 -y install cdemu-daemon
dnf5 -y install cdemu-client
dnf5 -y copr disable rok/cdemu

dnf5 -y copr enable faugus/faugus-launcher
dnf5 -y install faugus-launcher
dnf5 -y copr disable faugus/faugus-launcher

dnf5 clean all
