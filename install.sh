#!/bin/bash

DOT_DIRECTORY="${HOME}/github/dotfiles"

cd "${DOT_DIRECTORY}"

for f in .??*
do
	[[ ${f} = ".git" ]] && continue
	[[ ${f} = ".gitignore" ]] && continue
	ln -snfv "${DOT_DIRECTORY}/${f}" "${HOME}/${f}"
done

# nvim は隠しディレクトリではないので個別にリンクする
mkdir -p "${HOME}/.config"
ln -snfv "${DOT_DIRECTORY}/nvim" "${HOME}/.config/nvim"

# wezterm: Linux / macOS はシンボリックリンクで読ませる
ln -snfv "${DOT_DIRECTORY}/wezterm" "${HOME}/.config/wezterm"

# WSL の場合は Windows 側の WezTerm が読む %USERPROFILE%\.config\wezterm にもコピーする
# (Windows のプログラムは WSL 内のシンボリックリンクを辿れないため)
if [[ -n "${WSL_DISTRO_NAME}" ]] && command -v wslpath >/dev/null 2>&1; then
	win_home="$(wslpath "$(cmd.exe /c 'echo %USERPROFILE%' 2>/dev/null | tr -d '\r')")"
	if [[ -d "${win_home}" ]]; then
		win_wezterm="${win_home}/.config/wezterm"
		mkdir -p "${win_wezterm}"
		# .colorscheme / .background は実行時の状態ファイルなので残す
		if command -v rsync >/dev/null 2>&1; then
			rsync -a --delete --exclude '.colorscheme' --exclude '.background' "${DOT_DIRECTORY}/wezterm/" "${win_wezterm}/"
		else
			cp -r "${DOT_DIRECTORY}/wezterm/." "${win_wezterm}/"
		fi
		echo "wezterm: copied to ${win_wezterm}"
	fi
fi

# vscode: Windows 側の VS Code が読む %APPDATA%\Code\User に settings.json をコピーし、拡張機能を導入する
# (WSL 接続時も Windows 側のユーザー設定が使われる。シンボリックリンクは辿れないのでコピー)
if [[ -n "${WSL_DISTRO_NAME}" ]] && command -v wslpath >/dev/null 2>&1; then
	win_appdata="$(wslpath "$(cmd.exe /c 'echo %APPDATA%' 2>/dev/null | tr -d '\r')")"
	win_code_user="${win_appdata}/Code/User"
	if [[ -d "${win_code_user}" ]]; then
		if [[ -f "${win_code_user}/settings.json" ]] && ! cmp -s "${DOT_DIRECTORY}/vscode/settings.json" "${win_code_user}/settings.json"; then
			cp -v "${win_code_user}/settings.json" "${win_code_user}/settings.json.bak"
		fi
		cp -v "${DOT_DIRECTORY}/vscode/settings.json" "${win_code_user}/settings.json"

		# Windows 側 (UI) の拡張機能
		if command -v code >/dev/null 2>&1; then
			grep -v '^#' "${DOT_DIRECTORY}/vscode/extensions-windows.txt" | while read -r ext; do
				[[ -n "${ext}" ]] && code --install-extension "${ext}"
			done
		fi

		# WSL 側 (Remote-WSL サーバ) の拡張機能。サーバは初回 Remote-WSL 接続時に作られる
		code_server="$(ls -t "${HOME}"/.vscode-server/bin/*/bin/code-server 2>/dev/null | head -n 1)"
		if [[ -n "${code_server}" ]]; then
			grep -v '^#' "${DOT_DIRECTORY}/vscode/extensions-wsl.txt" | while read -r ext; do
				[[ -n "${ext}" ]] && "${code_server}" --install-extension "${ext}"
			done
		else
			echo "vscode: ~/.vscode-server が無いので WSL 側の拡張機能は未導入 (一度 Remote-WSL で接続してから再実行)"
		fi
	fi
fi
