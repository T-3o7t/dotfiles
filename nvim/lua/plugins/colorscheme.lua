-- 既定は tokyonight。比較用に catppuccin / kanagawa / gruvbox も入れてある（lazy = true なので
-- 起動コストは無く、:colorscheme <name> か <leader>uC の picker で切替時に読み込まれる）。
-- 決まったら既定にするものを lazy = false / priority = 1000 にし、config で colorscheme を呼ぶ。
-- 不要になったものはこのファイルから消して :Lazy clean。
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

  -- パステル寄りの暗色。:colorscheme catppuccin-mocha（latte / frappe / macchiato / mocha）
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    opts = {
      flavour = "mocha",
      integrations = { blink_cmp = true, gitsigns = true, telescope = true, which_key = true, treesitter_context = true },
    },
  },

  -- 和風の落ち着いたパレット。:colorscheme kanagawa-wave（wave / dragon / lotus）
  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    opts = {},
  },

  -- 暖色レトロ。旧 tender に近い雰囲気。:colorscheme gruvbox（contrast = "hard" | "" | "soft"）
  {
    "ellisonleao/gruvbox.nvim",
    lazy = true,
    opts = { contrast = "" },
  },
}
