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
		# .colorscheme は実行時の状態ファイルなので残す
		if command -v rsync >/dev/null 2>&1; then
			rsync -a --delete --exclude '.colorscheme' "${DOT_DIRECTORY}/wezterm/" "${win_wezterm}/"
		else
			cp -r "${DOT_DIRECTORY}/wezterm/." "${win_wezterm}/"
		fi
		echo "wezterm: copied to ${win_wezterm}"
	fi
fi
