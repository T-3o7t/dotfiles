-- 対象の言語（パーサを自動インストールし、そのファイルタイプでハイライト / インデントを有効化）
local languages = {
  "bash",
  "c",
  "cmake",
  "cpp",
  "lua",
  "make",
  "markdown",
  "markdown_inline",
  "query",
  "vim",
  "vimdoc",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main", -- main ブランチは旧 master と API が異なる（setup({ensure_installed}) は無い）
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").install(languages)

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
        callback = function(ev)
          -- パーサが無い filetype では start が失敗するので pcall
          if not pcall(vim.treesitter.start, ev.buf) then
            return
          end
          vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },

  -- スクロール時に現在の関数 / 構造体のヘッダを画面上部に固定表示
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "VeryLazy",
    opts = { max_lines = 3 },
  },
}
