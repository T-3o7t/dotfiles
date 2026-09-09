-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- ここには LazyVim の既定と衝突しない追加分だけを置く。
-- ウィンドウ / バッファ移動、行移動(<A-j>/<A-k>)、<C-s> 保存、]q/[q、コメント等は既定で入っている。

local map = vim.keymap.set

-- ビジュアルのインデントで選択を維持
map("x", "<", "<gv", { desc = "Indent left (keep selection)" })
map("x", ">", ">gv", { desc = "Indent right (keep selection)" })

-- 選択範囲へのペーストでレジスタを汚さない
map("x", "<leader>p", [["_dP]], { desc = "Paste without yank" })

-- スクロール / 検索移動時にカーソルを画面中央へ（LazyVim の検索方向正規化は維持）
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

-- C/C++: <leader>ch でソース <-> ヘッダ切替 は clangd extra が提供
