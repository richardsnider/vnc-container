#!/usr/bin/env bash
set -ex

echo "Installing kvm / qemu as directed by https://help.ubuntu.com/community/KVM/Installation"
kvm-ok
sudo apt-get install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils
sudo adduser `id -un` libvirt
sudo adduser `id -un` kvm

virsh list --all
