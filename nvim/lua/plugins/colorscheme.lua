-- tender（vim と同じ配色）/ tokyonight / catppuccin を <leader>ut で切替。選択は data ディレクトリに保存し次回起動時も維持する。
local state_file = vim.fn.stdpath("data") .. "/colorscheme"
local schemes = { "tender", "tokyonight", "catppuccin" }

local function saved_scheme()
  local f = io.open(state_file, "r")
  if not f then
    return schemes[1]
  end
  local name = vim.trim(f:read("*a") or "")
  f:close()
  return vim.tbl_contains(schemes, name) and name or schemes[1]
end

local function apply(name)
  vim.cmd.colorscheme(name) -- lazy = true のプラグインでも lazy.nvim が ColorSchemePre で自動読込する
  local f = io.open(state_file, "w")
  if f then
    f:write(name)
    f:close()
  end
end

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

      -- tender（colors/tender.vim）は文字色はそのまま、背景のグレー（#282828 / #202020）だけ黒にする
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "tender",
        callback = function()
          for _, g in ipairs({ "Normal", "SignColumn", "FoldColumn", "Folded", "EndOfBuffer" }) do
            local hl = vim.api.nvim_get_hl(0, { name = g })
            vim.api.nvim_set_hl(0, g, vim.tbl_extend("force", hl, { bg = "#000000", ctermbg = 16 }))
          end
          -- 元は fg = bg の太いグレー線なので、黒背景に細い線で出す
          vim.api.nvim_set_hl(0, "VertSplit", { fg = "#444444", ctermfg = 238 })
          vim.api.nvim_set_hl(0, "WinSeparator", { link = "VertSplit" })
        end,
      })

      apply(saved_scheme())

      vim.keymap.set("n", "<leader>ut", function()
        local cur = vim.g.colors_name or ""
        local idx = 0
        for i, name in ipairs(schemes) do
          if cur:find("^" .. name) then
            idx = i
          end
        end
        local next = schemes[idx % #schemes + 1]
        apply(next)
        vim.notify("colorscheme: " .. next)
      end, { desc = "Cycle colorscheme (tender / tokyonight / catppuccin)" })
    end,
  },

  -- パステル寄りの暗色。flavour: latte / frappe / macchiato / mocha
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    opts = {
      flavour = "mocha",
      integrations = { blink_cmp = true, gitsigns = true, telescope = true, which_key = true, treesitter_context = true },
    },
  },
}
