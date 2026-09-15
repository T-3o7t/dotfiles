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
}
