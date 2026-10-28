#!/bin/bash

set -ueox pipefail

echo "==> Install Fedora packages"

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

echo "==> Install virt-manager"

virt_manager_pkgs=(
	edk2-ovmf
	edk2-tools
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
)
dnf --setopt=install_weak_deps=False install -y "${virt_manager_pkgs[@]}"

echo "==> Install ROCm"

rocm_pkgs=(
	rocm-hip
	rocm-opencl
	rocm-clinfo
	rocm-smi
)
dnf remove -y mesa-libOpenCL # incompatible
dnf --setopt=install_weak_deps=False install -y "${rocm_pkgs[@]}"

echo "==> Install VSCode"

dnf config-manager addrepo --set=baseurl="https://packages.microsoft.com/yumrepos/vscode" --id="vscode"
dnf config-manager setopt vscode.enabled=0
dnf install --nogpgcheck --enable-repo="vscode" -y code

echo "==> Install Docker"

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

echo "==> Install Faugus Launcher"

dnf -y copr enable faugus/faugus-launcher
dnf -y install faugus-launcher
dnf -y copr disable faugus/faugus-launcher

echo "==> Disable NTFS nag"

systemctl disable --global ntfs-nag.service
systemctl mask --global ntfs-nag.service

echo "==> Disable ujust setup-virtualization"

sed -i '/import "\/usr\/share\/ublue-os\/just\/84-bazzite-virt.just"/d' /usr/share/ublue-os/justfile

echo "==> Fix /opt"

for dir in /var/opt/*/; do
	[[ -d "${dir}" ]] || continue
	dirname=$(basename "${dir}")
	mv "${dir}" "/usr/lib/opt/${dirname}"
	echo "L+ /var/opt/${dirname} - - - - /usr/lib/opt/${dirname}" >>/usr/lib/tmpfiles.d/opt-fix.conf
done

echo "==> Cleanup"

dnf clean all

rm -rf /tmp/*

# shellcheck disable=SC2114
rm -rf /var
mkdir -p /var/tmp
chmod -R 1777 /var/tmp
