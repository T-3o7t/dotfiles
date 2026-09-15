return {
  -- ディレクトリを通常バッファとして編集するファイラ（リネーム / 削除 / 作成は編集して :w）
  {
    "stevearc/oil.nvim",
    lazy = false, -- `nvim .` や `:e dir/` で netrw の代わりに開けるように起動時に読む
    dependencies = { "echasnovski/mini.icons" },
    keys = {
      { "-", "<cmd>Oil<CR>", desc = "Open parent directory (oil)" },
    },
    opts = {
      default_file_explorer = true, -- netrw を置き換える
      view_options = {
        show_hidden = true,
      },
      -- oil バッファ内: <CR> 開く / - 親へ / g? ヘルプ / <C-p> プレビュー / g. 隠しファイル切替
    },
  },

  -- 左側に常駐するツリーサイドバー（<leader>e でトグル）
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFindFile" },
    dependencies = { "echasnovski/mini.icons" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file tree" },
      { "<leader>E", "<cmd>NvimTreeFindFile<CR>", desc = "Reveal current file in tree" },
    },
    opts = {
      -- ディレクトリを開く役目は oil に任せる（nvim . で nvim-tree が出ないように）
      disable_netrw = false,
      hijack_netrw = false,
      hijack_directories = { enable = false },
      view = { width = 32 },
      renderer = {
        group_empty = true, -- 空の中間ディレクトリを 1 行にまとめる
      },
      filters = { dotfiles = false },
      -- ツリー内: <CR> 開く / a 作成 / d 削除 / r リネーム / H 隠しファイル切替 / g? ヘルプ
    },
  },
}
