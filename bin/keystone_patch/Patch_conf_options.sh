#!/bin/sh
set -e

# Env overrides: KEYSTONE (keystone のリポジトリ。MyPatches/ はその直下に置く)
cd "${KEYSTONE:-$HOME/github/keystone}"
git apply --check ./MyPatches/keystone_options.patch
git apply ./MyPatches/keystone_options.patch

#ch buildroot
#git apply --check ../MyPatches/buildroot_options.patch
#git apply ../MyPatches/buildroot_options.patch


