-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- yank ハイライト / カーソル位置復元 / 保存時 mkdir 等は LazyVim が既に設定済み。

-- コメント行の下で o/O や Enter を押したときにコメントリーダーを自動挿入しない
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("user_formatoptions", { clear = true }),
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})
