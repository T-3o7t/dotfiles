#!/bin/bash
# ~/tex_thesis を OneDrive 上のバックアップへ同期する。作業の区切りごとに実行する。
# ビルド生成物 (out/) は送らない。上書き・削除されるファイルは
# バックアップ先の隣の latex_thesis_history/<日時>/ に退避するので、誤った変更を送っても戻せる。
#
# Usage: backup_thesis.sh [-n] [--delete]
#   -n, --dry-run  何が送られるかを表示するだけで、実際にはコピーしない
#   --delete       ローカルで消したファイルをバックアップ先からも消す (消したものは history に残る)
#   -h, --help     このヘルプを表示する
#
# Env overrides: SRC (同期元), DEST (OneDrive 上のバックアップ先。既定は Windows の OneDrive 配下の Lab/thesis/latex_thesis)
set -e

SRC="${SRC:-$HOME/tex_thesis}"
# Windows 側の環境変数 (%OneDriveCommercial% など) を WSL のパスで返す。未定義なら空
win_env_path() {
    local v
    v="$(cd /mnt/c && cmd.exe /c "echo %$1%" 2>/dev/null | tr -d '\r')"
    [ -n "${v}" ] && [ "${v}" != "%$1%" ] && wslpath "${v}"
}
ONEDRIVE="$(win_env_path OneDriveCommercial || win_env_path OneDrive || true)"
DEST="${DEST:-${ONEDRIVE}/Lab/thesis/latex_thesis}"
HISTORY="$(dirname "${DEST}")/latex_thesis_history/$(date +%Y%m%d-%H%M%S)"

# 冒頭のコメント (このファイルの説明) をそのままヘルプとして表示する
show_help() {
    sed -n '2,/^set -e/{/^#/s/^# \{0,1\}//p}' "$0"
}

opts=()
for arg in "$@"; do
    case "${arg}" in
        -n|--dry-run) opts+=(--dry-run) ;;
        --delete)     opts+=(--delete) ;;
        -h|--help)    show_help; exit 0 ;;
        *)
            echo "error: 不明なオプション: ${arg}" >&2
            echo "usage: $(basename "$0") [-n] [--delete] (詳しくは -h)" >&2
            exit 1
            ;;
    esac
done

if [ ! -d "${SRC}" ]; then
    echo "error: ${SRC} not found (set SRC)" >&2
    exit 1
fi
# OneDrive 側でフォルダを移動・改名した場合に、別の場所へ新しく作ってしまわないよう止める
if [ ! -d "${DEST}" ]; then
    echo "error: ${DEST} not found; OneDrive 側でフォルダを移動した場合は DEST を直す" >&2
    exit 1
fi

# /mnt/c (NTFS) はパーミッションと所有者を保持できないので -a ではなく -rt を使う。
# 中身で比較し (-c)、内容が同じで時刻だけ違うファイルは送らず history にも入れない
rsync -rtc --itemize-changes \
    --exclude 'out/' \
    --backup --backup-dir="${HISTORY}" \
    "${opts[@]}" \
    "${SRC}/" "${DEST}/"

if [ -d "${HISTORY}" ]; then
    echo "上書き・削除前のファイル: ${HISTORY}"
fi
echo "backup done: ${DEST}"
