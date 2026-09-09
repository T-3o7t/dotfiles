-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

-- ~/.local/bin を PATH 先頭へ（GUI 起動などでも win32yank.exe を解決できるように）
vim.env.PATH = vim.fn.expand("~/.local/bin") .. ":" .. vim.env.PATH

-- file format
vim.opt.fileformat = "unix"
vim.opt.fenc = "utf-8"

-- view
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.laststatus = 3
vim.opt.mouse = ""
vim.opt.winborder = "rounded" -- ホバー / フロートの枠を角丸に（Neovim 0.11+）

-- indent（スペース展開・4 幅。shiftwidth=0 は tabstop に追従、softtabstop=-1 は shiftwidth に追従）
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = -1
vim.opt.shiftwidth = 0

-- colors
vim.opt.termguicolors = true
vim.opt.winblend = 0
vim.opt.pumblend = 0

-- search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- others
vim.opt.list = true
vim.opt.listchars = "tab:▸-"

-- WSL クリップボード連携（win32yank 経由。旧: paste ごとに powershell.exe を起動していて遅かった）
if vim.fn.has("wsl") == 1 then
  vim.g.clipboard = {
    name = "win32yank-wsl",
    copy = {
      ["+"] = "win32yank.exe -i --crlf",
      ["*"] = "win32yank.exe -i --crlf",
    },
    paste = {
      ["+"] = "win32yank.exe -o --lf",
      ["*"] = "win32yank.exe -o --lf",
    },
    cache_enabled = 0,
  }
end
