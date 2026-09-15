return {
  -- LSP サーバ等のインストーラ（:Mason）
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {},
  },

  -- Mason で入れたサーバを自動で vim.lsp.enable する
  {
    "mason-org/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
    opts = {
      ensure_installed = { "clangd", "neocmakelsp", "lua_ls" },
    },
  },

  -- 各サーバの既定設定（lsp/*.lua）を提供。Neovim 0.11+ の vim.lsp.config で上書きする
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      vim.lsp.config("clangd", {
        cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu" },
      })
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
          },
        },
      })

      vim.diagnostic.config({
        virtual_text = true,
        severity_sort = true,
      })

      -- LSP が付いたバッファだけに効くキーマップ（K / ]d / [d は Neovim 組込）
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
        callback = function(ev)
          local function map(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, desc = desc })
          end
          local tb = require("telescope.builtin")
          map("gd", tb.lsp_definitions, "Goto definition")
          map("gr", tb.lsp_references, "References")
          map("gI", tb.lsp_implementations, "Goto implementation")
          map("<leader>cs", tb.lsp_document_symbols, "Document symbols")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("<leader>cr", vim.lsp.buf.rename, "Rename")
          map("<leader>cf", function()
            vim.lsp.buf.format({ async = true })
          end, "Format")
          map("<leader>cd", vim.diagnostic.open_float, "Line diagnostics")
        end,
      })
    end,
  },

  -- nvim 設定編集時に vim.* / プラグイン API の補完を lua_ls に教える
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
}
