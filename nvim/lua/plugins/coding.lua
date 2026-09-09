return {
  -- Treesitter パーサ（clangd / cmake extra でも一部入るが念のため）
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "c",
        "cpp",
        "cmake",
        "make",
        "bash",
        "lua",
        "vim",
        "vimdoc",
        "markdown",
        "markdown_inline",
      })
    end,
  },

  -- この環境の Mason は pip 系ツールの venv を作れない（python3-venv/ensurepip 不足）。
  -- clang-format / cmakelang / cmakelint は pip --user で ~/.local/bin に導入済みなので、
  -- Mason の ensure_installed からは外して毎起動の失敗リトライを防ぐ。
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      local drop = { ["clang-format"] = true, cmakelang = true, cmakelint = true }
      opts.ensure_installed = vim.tbl_filter(function(t)
        return not drop[t]
      end, opts.ensure_installed or {})
    end,
  },
}
