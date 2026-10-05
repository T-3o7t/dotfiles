#!/bin/bash
# Env overrides: QEMU_SRC (git_qemu.sh で clone した qemu), BUILD_DIR (ビルド先), PREFIX (インストール先)
QEMU_SRC="${QEMU_SRC:-$HOME/qemu}"
BUILD_DIR="${BUILD_DIR:-$HOME/build_qemu}"
PREFIX="${PREFIX:-$HOME/qemu-riscv}"

mkdir -p "${BUILD_DIR}"
cd "${BUILD_DIR}" || exit 1

"${QEMU_SRC}/configure" \
--prefix="${PREFIX}" \
--target-list=riscv64-linux-user,riscv64-softmmu,x86_64-softmmu,x86_64\
-linux-user \
--enable-tpm    \
--enable-slirp  \
--enable-virtfs \
--enable-kvm \
--enable-keyring \
--enable-attr \
--enable-auth-pam \
--enable-curses \
--enable-fuse \
--enable-fuse-lseek \
--enable-gnutls \
--enable-linux-io-uring \
--enable-numa \
--enable-qcow1 \
--enable-rdma \
--enable-seccomp \
--enable-selinux \
--enable-virtfs \
--enable-vmdk \
--enable-pie

