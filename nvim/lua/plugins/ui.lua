return {
  -- which-key: モダンなプリセットで見やすく（キーマップの発見性アップ）
  {
    "folke/which-key.nvim",
    opts = {
      preset = "modern",
    },
  },

  -- noice: LSP ホバー / シグネチャに枠線
  {
    "folke/noice.nvim",
    opts = {
      presets = {
        lsp_doc_border = true,
      },
    },
  },

  -- lualine: ファイル名を相対パス表示に
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      for _, comp in ipairs(opts.sections.lualine_c or {}) do
        if type(comp) == "table" and comp[1] == "filename" then
          comp.path = 1
        end
      end
    end,
  },
}
