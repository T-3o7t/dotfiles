-- プラグインに依存しないキーマップ。
-- プラグイン固有のもの（telescope / LSP / gitsigns）は lua/plugins/ の各 spec 側に置く。

local map = vim.keymap.set

-- ウィンドウ移動 (<C-h/j/k/l>) は lua/plugins/smart-splits.lua で定義 (WezTerm pane とも連携)

-- バッファ切替 / 閉じる
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })

-- 行移動（Alt-j / Alt-k）
map("n", "<A-j>", "<cmd>m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<CR>==", { desc = "Move line up" })
map("i", "<A-j>", "<Esc><cmd>m .+1<CR>==gi", { desc = "Move line down" })
map("i", "<A-k>", "<Esc><cmd>m .-2<CR>==gi", { desc = "Move line up" })
map("x", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("x", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- 保存
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<CR><Esc>", { desc = "Save file" })

-- ビジュアルのインデントで選択を維持
map("x", "<", "<gv", { desc = "Indent left (keep selection)" })
map("x", ">", ">gv", { desc = "Indent right (keep selection)" })

-- 選択範囲へのペーストでレジスタを汚さない
map("x", "<leader>p", [["_dP]], { desc = "Paste without yank" })

-- スクロール / 検索移動時にカーソルを画面中央へ（n は常に前方、N は常に後方に正規化）
map("n", "n", "'Nn'[v:searchforward] . 'zzzv'", { expr = true, desc = "Next search result (centered)" })
map("n", "N", "'nN'[v:searchforward] . 'zzzv'", { expr = true, desc = "Prev search result (centered)" })
map("x", "n", "'Nn'[v:searchforward] . 'zzzv'", { expr = true, desc = "Next search result (centered)" })
map("x", "N", "'nN'[v:searchforward] . 'zzzv'", { expr = true, desc = "Prev search result (centered)" })
map("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

-- Esc で検索ハイライトも消す
map("n", "<Esc>", "<cmd>nohlsearch<CR><Esc>", { desc = "Clear search highlight" })

-- ターミナルモードを抜ける
map("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

-- 挿入モードを jk で抜ける（不要なら下の 1 行を削除）
map("i", "jk", "<Esc>", { desc = "Exit insert mode" })

-- プラグイン管理画面
map("n", "<leader>l", "<cmd>Lazy<CR>", { desc = "Lazy" })

-- :W / :Q などの Shift 打ち間違いを許容する（vi 由来の癖への対策）
local function cmd_alias(name, target)
  vim.api.nvim_create_user_command(name, function(o)
    vim.cmd(target .. (o.bang and "!" or "") .. (o.args ~= "" and (" " .. o.args) or ""))
  end, { bang = true, nargs = "*" })
end

for name, target in pairs({
  W = "write",
  Q = "quit",
  Qa = "qall",
  QA = "qall",
  Wa = "wall",
  WA = "wall",
  Wq = "wq",
  WQ = "wq",
  Wqa = "wqa",
  WQA = "wqa",
  X = "xit",
  Xa = "xall",
  XA = "xall",
}) do
  cmd_alias(name, target)
end
