-- leaderの設定
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
-- options を早めに読み込む（keymaps / autocmds は LazyVim が VeryLazy で自動読込）
require("config.options")
-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
