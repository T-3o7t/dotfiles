#!/bin/bash
# build_qemu.sh が参照する場所 (QEMU_SRC, 既定 ~/qemu) に clone する
QEMU_SRC="${QEMU_SRC:-$HOME/qemu}"
git clone https://gitlab.com/qemu-project/qemu.git "${QEMU_SRC}"
