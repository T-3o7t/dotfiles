return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000, -- 他のプラグインより先に読み込む
    opts = {
      style = "storm", -- night | storm | moon | day（1 行で切替）
      styles = {
        comments = { italic = true },
      },
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      -- colors/tender.vim もあるので :colorscheme tender で切替可能
      vim.cmd.colorscheme("tokyonight")
    end,
  },
}
