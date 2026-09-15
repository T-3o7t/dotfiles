return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = { "nvim-lua/plenary.nvim", "echasnovski/mini.icons" },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<leader><space>", "<cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Grep (ripgrep)" },
      { "<leader>/", "<cmd>Telescope live_grep<CR>", desc = "Grep (ripgrep)" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
      { "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Recent files" },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help tags" },
      { "<leader>fd", "<cmd>Telescope diagnostics<CR>", desc = "Diagnostics" },
      {
        "<leader>uC",
        function()
          -- lazy = true のカラースキームは読込前だと一覧に出ないので、colors/ を持つプラグインを先に全部読む
          local names = {}
          for _, p in pairs(require("lazy.core.config").plugins) do
            if not p._.loaded and vim.uv.fs_stat(p.dir .. "/colors") then
              names[#names + 1] = p.name
            end
          end
          require("lazy").load({ plugins = names })
          require("telescope.builtin").colorscheme({ enable_preview = true })
        end,
        desc = "Colorscheme (preview)",
      },
    },
    opts = {},
  },
}
