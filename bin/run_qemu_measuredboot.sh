#!/bin/bash
# Env overrides: IMG (起動するディスクイメージ), UBOOT (-kernel に渡す U-Boot)
IMG="${IMG:-$HOME/image/ubuntu-24.04.4-preinstalled-server-riscv64.img}"
UBOOT="${UBOOT:-$HOME/github/u-boot/u-boot_measuredboot.elf}"

mkdir -p /tmp/emulated_tpm_qemu;

swtpm socket --tpmstate dir=/tmp/emulated_tpm_qemu \
         --ctrl type=unixio,path=/tmp/emulated_tpm_qemu/swtpm-sock \
         --log level=20 --tpm2 \
         --daemon;

qemu-system-riscv64 \
  -machine virt -cpu rv64 -m 4G -smp 2 \
  -nographic \
  -kernel "${UBOOT}" \
  -netdev user,id=net0,hostfwd=tcp::2222-:22 \
  -device virtio-net-device,netdev=net0 \
  -device virtio-rng-pci \
  -drive file="${IMG}",format=raw,if=virtio \
  -chardev socket,id=chrtpm,path=/tmp/emulated_tpm_qemu/swtpm-sock \
  -tpmdev emulator,id=tpm0,chardev=chrtpm \
  -device tpm-tis-device,tpmdev=tpm0
