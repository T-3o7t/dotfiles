return {
  {
    "saghen/blink.cmp",
    version = "1.*", -- release にはビルド済みの fuzzy matcher が同梱される
    event = "InsertEnter",
    opts = {
      -- <CR> で確定、<C-n>/<C-p> または <Up>/<Down> で選択、<C-e> で閉じる
      keymap = { preset = "enter" },
      completion = {
        documentation = { auto_show = true },
      },
      sources = {
        default = { "lsp", "path", "buffer" },
      },
      signature = { enabled = true },
    },
  },
}
