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
