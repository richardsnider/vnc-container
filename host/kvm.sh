#!/usr/bin/env bash
set -ex

echo "Installing kvm / qemu as directed by https://help.ubuntu.com/community/KVM/Installation"
sudo apt-get install --yes qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virtinst virt-top curl
sudo adduser `id -un` libvirt
sudo adduser `id -un` kvm

kvm-ok

ISO_URL=http://releases.ubuntu.com/19.10/ubuntu-19.10-live-server-amd64.iso
ISO_FILE=$HOME/Downloads/image.iso
if [ ! -f "$ISO_FILE" ]; then
    curl --location $UBUNTU_ISO_URL --output $ISO_FILE
fi

VM_NAME=perennial
virt-install --name=$VM_NAME \
    --vcpus=1 \
    --memory=1024 \
    --cdrom=$ISO_FILE \
    --disk size=5

# virsh start $VM_NAME
virsh list --all
virsh dominfo $VM_NAME

virsh autostart $VM_NAME
virsh console $VM_NAME

# virsh save $VM_NAME /data/vm
# virsh restore /data/vm
# virsh suspend $VM_NAME
# virsh resume $VM_NAME
# virsh reboot $VM_NAME
# virsh shutdown $VM_NAME
# virsh undefine $VM_NAME
# virsh undefine --domain $VM_NAME
# rm -rf /nfswheel/kvm/openbsd.qcow2
