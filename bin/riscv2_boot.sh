#!/bin/bash
# Env overrides: BUSID (usbipd list で確認した BUSID), BIN (書き込む bin の Windows パス。既定は Windows のデスクトップ上),
#                DRIVE (書き込み先ドライブ)
BUSID="${BUSID:-3-1}"
BIN="${BIN:-bootloader_addr5_secboot.bin}"
DRIVE="${DRIVE:-D:/}"

# 1. USBデバイスをWSLにアタッチ（管理者権限が必要なため昇格して実行）
powershell.exe -Command "Start-Process powershell -Verb RunAs -ArgumentList '-Command usbipd attach --wsl --busid ${BUSID}; usbipd list'"

# 2. シリアル通信
sudo minicom

# 3. ファイルコピー（BIN が相対パスなら Windows のデスクトップ (OneDrive へのリダイレクトも考慮) 基準。リセットによる切断は無視）
powershell.exe -Command "\$bin = '${BIN}'; if (-not [IO.Path]::IsPathRooted(\$bin)) { \$bin = Join-Path ([Environment]::GetFolderPath('Desktop')) \$bin }; try { Copy-Item \$bin -Destination '${DRIVE}' -ErrorAction Stop } catch { Write-Host 'Copy triggered device reset (expected)' }"
