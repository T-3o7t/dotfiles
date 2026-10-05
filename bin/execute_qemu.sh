#!/bin/bash
# Env overrides: IMG (起動するディスクイメージ), UBOOT (-kernel に渡す U-Boot)
IMG="${IMG:-$HOME/image/ubuntu-24.04.4-preinstalled-server-riscv64.img}"
UBOOT="${UBOOT:-/usr/lib/u-boot/qemu-riscv64_smode/uboot.elf}"

qemu-system-riscv64 \
  -machine virt -cpu rv64 -m 4G -smp 2 \
  -nographic \
  -kernel "${UBOOT}" \
  -netdev user,id=net0,hostfwd=tcp::2222-:22 \
  -device virtio-net-device,netdev=net0 \
  -device virtio-rng-pci \
  -drive file="${IMG}",format=raw,if=virtio
