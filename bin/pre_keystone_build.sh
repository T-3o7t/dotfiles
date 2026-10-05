# Keystone をビルドする前に、現在のシェルで source して使う (実行しても親シェルには反映されない)
#   source ~/bin/pre_keystone_build.sh
# Env overrides: KEYSTONE (keystone のリポジトリ)
export KEYSTONE="${KEYSTONE:-$HOME/github/keystone}"
export KEYSTONE_BOOTROM="${KEYSTONE}/bootrom"
export KEYSTONE_SM="${KEYSTONE}/sm"
export KEYSTONE_SDK="${KEYSTONE}/sdk"
export KEYSTONE_RUNTIME="${KEYSTONE}/runtime"
export KEYSTONE_DRIVER="${KEYSTONE}/linux-keystone-driver"
export KEYSTONE_EXAMPLES="${KEYSTONE}/examples"
# このファイルと同じディレクトリの clean-wsl-path.sh で PATH から空白入りの Windows パスを除く
source "$(dirname "${BASH_SOURCE[0]}")/clean-wsl-path.sh"
