#!/bin/bash

set -x

# Env overrides: ATTEST_DIR (差し替え用ファイルの置き場), GITHUB_DIR (keystone を clone したディレクトリ)
ATTEST_DIR="${ATTEST_DIR:-$HOME/attest}"
GITHUB_DIR="${GITHUB_DIR:-$HOME/github}"
KEYSTONE="${GITHUB_DIR}/keystone"

RUN_MK=keystone/mkutils/plat/generic/run.mk
QEMU_MK=keystone/buildroot/package/qemu/qemu.mk
VIRT_C=keystone/build-generic64/buildroot.build/build/host-qemu-7.2.1/hw/riscv/virt.c
VIRT_H=keystone/build-generic64/buildroot.build/build/host-qemu-7.2.1/include/hw/riscv/virt.h


if [ ! -f $GITHUB_DIR/${RUN_MK}_ORG ]; then
    mv $GITHUB_DIR/$RUN_MK $GITHUB_DIR/${RUN_MK}_ORG
    cp $ATTEST_DIR/$RUN_MK $GITHUB_DIR/$RUN_MK
fi

if [ ! -f $GITHUB_DIR/${QEMU_MK}_ORG ]; then
    mv $GITHUB_DIR/$QEMU_MK $GITHUB_DIR/${QEMU_MK}_ORG
    cp $ATTEST_DIR/$QEMU_MK $GITHUB_DIR/$QEMU_MK
fi

if [ ! -f $GITHUB_DIR/${VIRT_C}_ORG ]; then
    mv $GITHUB_DIR/$VIRT_C $GITHUB_DIR/${VIRT_C}_ORG
    cp $ATTEST_DIR/$VIRT_C $GITHUB_DIR/$VIRT_C
fi

if [ ! -f $GITHUB_DIR/${VIRT_H}_ORG ]; then
    mv $GITHUB_DIR/$VIRT_H $GITHUB_DIR/${VIRT_H}_ORG
    cp $ATTEST_DIR/$VIRT_H $GITHUB_DIR/$VIRT_H
fi

cd "${KEYSTONE}/build-generic64/buildroot.build" || exit 1

KEYSTONE="${KEYSTONE}" \
KEYSTONE_BOOTROM="${KEYSTONE}/bootrom" \
KEYSTONE_SM="${KEYSTONE}/sm" \
KEYSTONE_SDK="${KEYSTONE}/sdk" \
KEYSTONE_RUNTIME="${KEYSTONE}/runtime" \
KEYSTONE_DRIVER="${KEYSTONE}/linux-keystone-driver" \
KEYSTONE_EXAMPLES="${KEYSTONE}/examples" \
make host-qemu-rebuild V=1 2>&1 | tee host-qemu-rebuild.log

cp -a host/bin/qemu-system-riscv64 host/bin/qemu-system-riscv64.bak-$(date +%Y%m%d-%H%M%S)
cp -a per-package/host-qemu/host/bin/qemu-system-riscv64 host/bin/qemu-system-riscv64
