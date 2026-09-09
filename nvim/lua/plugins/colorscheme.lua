return {
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "storm", -- night | storm | moon | day（1 行で切替）
      styles = {
        comments = { italic = true },
      },
    },
  },
  { "LazyVim/LazyVim", opts = { colorscheme = "tokyonight" } },
}
