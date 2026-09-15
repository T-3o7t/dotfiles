-- PATH 先頭に追加:
--   ~/.local/bin                 手動導入ツール（GUI 起動でも解決できるように）
--   ~/.local/share/nvim/mason/bin  Mason 導入の clangd / lua-language-server / tree-sitter CLI
--   （mason.nvim は :Mason 実行時まで遅延読込なので、起動時から解決できるようここで通しておく）
vim.env.PATH = vim.fn.expand("~/.local/bin") .. ":" .. vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH

-- file format
vim.opt.fileformat = "unix"
vim.opt.fenc = "utf-8"

-- view
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.laststatus = 3 -- グローバルステータスライン
vim.opt.mouse = ""
vim.opt.winborder = "rounded" -- ホバー / フロートの枠を角丸に（Neovim 0.11+）
vim.opt.cursorline = true
vim.opt.scrolloff = 4
vim.opt.sidescrolloff = 8
vim.opt.wrap = false
vim.opt.showmode = false -- モードは lualine が表示
vim.opt.splitright = true
vim.opt.splitbelow = true

-- indent（スペース展開・4 幅。shiftwidth=0 は tabstop に追従、softtabstop=-1 は shiftwidth に追従）
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = -1
vim.opt.shiftwidth = 0
vim.opt.smartindent = true

-- colors
vim.opt.termguicolors = true
vim.opt.winblend = 0
vim.opt.pumblend = 0

-- search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = "nosplit" -- :s の置換結果をライブプレビュー

-- others
vim.opt.list = true
vim.opt.listchars = "tab:▸-"
vim.opt.undofile = true -- 終了後も undo 履歴を保持
vim.opt.confirm = true -- 未保存で :q した時などに確認ダイアログ
vim.opt.updatetime = 200 -- CursorHold / swap 書込の間隔
vim.opt.timeoutlen = 300 -- which-key のポップアップまでの時間
vim.opt.clipboard = "unnamedplus" -- yank / paste を OS クリップボードと共有

-- WSL クリップボード連携（win32yank 経由。Windows 側 Neovim 同梱の win32yank.exe が PATH にある前提）
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
