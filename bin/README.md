# bin
shellscript

# installation
```bash
sudo apt update
sudo apt install -y \
build-essential \
python3-venv \
ninja-build \
libglib2.0-dev \
libncurses5-dev libncursesw5-dev \
swtpm \
qemu-system-misc \
u-boot-qemu
```

# usage
- Paths are based on $HOME (qemu source: ~/qemu, build: ~/build_qemu, install: ~/qemu-riscv, disk image: ~/image). Override with env vars such as QEMU_SRC / BUILD_DIR / PREFIX / IMG / UBOOT
- Windows paths (OneDrive, Desktop, Tera Term) are resolved from the Windows environment, so the Windows user name does not matter
- Use shell scripts execute_qemu.sh and execute_qemu_tpm.sh depending on whether or not TPM is used

```bash
./pre_build_qemu.sh
./git_qemu.sh
./build_qemu.sh
mkdir image
cd !$
./kernel_image.sh
./execute_qemu.sh or ./execute_qemu_tpm.sh
```
