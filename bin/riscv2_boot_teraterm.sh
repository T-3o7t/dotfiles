#!/bin/bash
# --- 設定 (環境変数で上書き可) ---
COM="${COM:-5}"            # デバイスマネージャで確認したCOM番号
BAUD="${BAUD:-115200}"
BIN="${BIN:-bootloader_addr5_secboot.bin}"  # 書き込む bin の Windows パス。相対パスなら Windows のデスクトップ基準
DRIVE="${DRIVE:-D:/}"      # 書き込み先ドライブ

# Windows 側の環境変数 (%LOCALAPPDATA% など) を WSL のパスで返す。未定義なら空
win_env_path() {
    local v
    v="$(cd /mnt/c && cmd.exe /c "echo %$1%" 2>/dev/null | tr -d '\r')"
    [ -n "${v}" ] && [ "${v}" != "%$1%" ] && wslpath "${v}"
}

# Tera Term: TTERM 未指定ならユーザー / システムのインストール先を順に探す
if [ -z "${TTERM}" ]; then
    for d in "$(win_env_path LOCALAPPDATA)/Programs" "$(win_env_path ProgramFiles)" "$(win_env_path 'ProgramFiles(x86)')"; do
        for t in "${d}"/teraterm*/ttermpro.exe; do
            [ -f "${t}" ] && TTERM="${t}" && break 2
        done
    done
fi
if [ ! -f "${TTERM}" ]; then
    echo "error: ttermpro.exe が見つかりません (TTERM=/mnt/c/.../ttermpro.exe で指定)" >&2
    exit 1
fi

# 1. Tera Termでシリアルポートを開く（usbipd attach / minicom は不要）
"$TTERM" /C="$COM" /BAUD="$BAUD" &

# 2. binファイルをD:へ書き込み（リセットによる切断は無視）
powershell.exe -Command "\$bin = '${BIN}'; if (-not [IO.Path]::IsPathRooted(\$bin)) { \$bin = Join-Path ([Environment]::GetFolderPath('Desktop')) \$bin }; try { Copy-Item \$bin -Destination '${DRIVE}' -ErrorAction Stop } catch { Write-Host 'Copy triggered device reset (expected)' }"
