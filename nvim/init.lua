-- leader の設定（プラグイン読込より前に必要）
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.terminal")
-- lazy.nvim の bootstrap と lua/plugins/*.lua の読込
require("config.lazy")
