#!/bin/bash

set -ueox pipefail

fedora_pkgs=(
	android-tools
	bubblewrap
	dosbox-staging
	firejail
	flatpak-builder
	git-credential-libsecret
	sysprof
)
dnf install -y "${fedora_pkgs[@]}"

virt_manager_pkgs=(
	guestfs-tools
	libvirt
	libvirt-nss
	qemu
	qemu-char-spice
	qemu-device-display-virtio-gpu
	qemu-device-display-virtio-vga
	qemu-device-usb-redirect
	qemu-img
	qemu-kvm
	qemu-system-x86-core
	qemu-user-binfmt
	qemu-user-static
	virt-manager
	virt-v2v
	# Install pinned version of edk2-ovmf until fixes arrive.
	# See:
	#   - https://github.com/ublue-os/bazzite/issues/5857
	https://kojipkgs.fedoraproject.org/packages/edk2/20260508/8.fc44/x86_64/edk2-tools-20260508-8.fc44.x86_64.rpm
	https://kojipkgs.fedoraproject.org//packages/edk2/20260508/8.fc44/noarch/edk2-ovmf-20260508-8.fc44.noarch.rpm
)
dnf --setopt=install_weak_deps=False install -y "${virt_manager_pkgs[@]}"

rocm_pkgs=(
	rocm-hip
	rocm-opencl
	rocm-clinfo
	rocm-smi
)
dnf remove -y mesa-libOpenCL # incompatible
dnf --setopt=install_weak_deps=False install -y "${rocm_pkgs[@]}"

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

# Load iptable_nat module for docker-in-docker.
# See:
#   - https://github.com/ublue-os/bluefin/issues/2365
#   - https://github.com/devcontainers/features/issues/1235
mkdir -p /etc/modules-load.d && cat >>/etc/modules-load.d/ip_tables.conf <<EOF
iptable_nat
EOF

dnf -y copr enable faugus/faugus-launcher
dnf -y install faugus-launcher
dnf -y copr disable faugus/faugus-launcher

systemctl disable --global ntfs-nag.service
systemctl mask --global ntfs-nag.service

for dir in /var/opt/*/; do
	[[ -d "${dir}" ]] || continue
	dirname=$(basename "${dir}")
	mv "${dir}" "/usr/lib/opt/${dirname}"
	echo "L+ /var/opt/${dirname} - - - - /usr/lib/opt/${dirname}" >>/usr/lib/tmpfiles.d/opt-fix.conf
done

dnf clean all

rm -rf /tmp/*

# shellcheck disable=SC2114
rm -rf /var
mkdir -p /var/tmp
chmod -R 1777 /var/tmp
