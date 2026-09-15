return {
  -- アイコン（lualine / telescope 用。nvim-web-devicons 互換 API も提供）
  {
    "echasnovski/mini.icons",
    lazy = true,
    opts = {},
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },

  -- ステータスライン
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "echasnovski/mini.icons" },
    opts = {
      options = {
        globalstatus = true,
      },
      sections = {
        lualine_c = { { "filename", path = 1 } }, -- 相対パス表示
        lualine_x = { "lsp_status", "filetype" },
      },
    },
  },

  -- which-key: <leader> 後のキー候補をポップアップ表示
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      spec = {
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code" },
        { "<leader>f", group = "find" },
        { "<leader>g", group = "git" },
        { "<leader>u", group = "ui" },
      },
    },
  },
}
