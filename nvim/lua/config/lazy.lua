local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- lua/plugins/*.lua がそれぞれプラグイン spec のテーブルを返す
    { import = "plugins" },
  },
  defaults = {
    -- 各 spec で event / cmd / keys / ft を指定したものだけ遅延読込する
    lazy = false,
    version = false, -- 常に最新 commit（semver を持つプラグインは個別に version 指定）
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  rocks = { enabled = false }, -- luarocks を要するプラグインは無いので checkhealth の警告を抑止
  checker = {
    enabled = true, -- 定期的に更新を確認
    notify = false, -- 通知は出さない（:Lazy で確認）
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
