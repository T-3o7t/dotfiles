-- leader の設定（プラグイン読込より前に必要）
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.options")
require("config.keymaps")
require("config.autocmds")

if vim.g.vscode then
  -- vscode-neovim から起動された場合: UI 系プラグインは VS Code が担うので読まず、
  -- telescope / LSP / gitsigns 等のキーマップを VS Code のコマンドへ割り当てる
  require("config.vscode")
else
  require("config.terminal")
  -- lazy.nvim の bootstrap と lua/plugins/*.lua の読込
  require("config.lazy")
end
