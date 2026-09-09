# Neovim config (LazyVim ベース)

WSL + wezterm 上で使う Neovim 設定。[LazyVim](https://github.com/LazyVim/LazyVim) スターターをベースにしている。

## 構成

| パス | 役割 |
|---|---|
| `init.lua` | leader 設定と `config.lazy` の読み込み |
| `lua/config/options.lua` | オプション（WSL クリップボード、インデント、外観など） |
| `lua/config/keymaps.lua` | LazyVim 既定と衝突しない追加キーマップ |
| `lua/config/autocmds.lua` | 追加 autocmd |
| `lua/config/lazy.lua` | lazy.nvim ブートストラップ |
| `lua/plugins/*.lua` | プラグインの追加・上書き（`colorscheme` / `ui` / `coding`） |
| `lazyvim.json` | 有効化している LazyVim extras |
| `lazy-lock.json` | プラグインのバージョン固定 |

## 依存（設定リポジトリ外）

このマシンの Mason は Python venv を作れない（`python3-venv` / `ensurepip` 不足）ため、以下は
`~/.local/bin` に手動導入している。**別マシンでは各自インストールが必要。**

| ツール | 用途 | 入手方法 |
|---|---|---|
| `win32yank.exe` | WSL クリップボード連携 | [equalsraf/win32yank](https://github.com/equalsraf/win32yank) の releases から DL して `~/.local/bin` へ |
| `clang-format` | C/C++ 整形（CLI 用途。nvim 内の整形は clangd LSP が担当するので必須ではない） | `pip install --user --break-system-packages clang-format` |
| `cmakelint` / `cmakelang` | CMake の lint / 整形 | `pip install --user --break-system-packages cmakelint cmakelang` |

`clangd` と `neocmakelsp` は Mason で導入済み。`sudo apt install python3-venv` 後は `:Mason` で
pip 系ツールも入れ直せる（その場合 `lua/plugins/coding.lua` の `ensure_installed` 除外は不要になる）。

## メモ

- C/C++ のクロスファイル補完・診断をフルに使うにはプロジェクト直下に `compile_commands.json`
  （CMake: `-DCMAKE_EXPORT_COMPILE_COMMANDS=1`、または `bear -- make`）か `.clangd` が必要。
- この設定は `~/.config/nvim` と `~/github/dotfiles/nvim` の 2 か所にコピーで存在する。
  編集後は両者を同期してから commit する。

---

## 変更履歴

**記法:** 変更したら `### YYYY-MM-DD — 概要` の見出しを **この行のすぐ下（新しいものが上）** に追加し、
変更点を箇条書きで書く。関連するファイル名を添える。

### 2026-09-09 — 初期整備（C/C++ 対応・UI・キーマップ・クリップボード）

ほぼ素の LazyVim スターターに対して以下を実施。

**構成の整理**
- `init.lua`: 誤ったモジュール名でコメントアウトされていた `require` の死んだ行を削除
  （keymaps / autocmds は LazyVim が VeryLazy で自動読込するため）
- `lua/plugins/example.lua` を削除（廃止 API を参照する死にコード）

**`lua/config/options.lua`**
- `vim.opt.syntax = "on"`（Treesitter と二重）とコメントアウトされた透過設定ブロックを削除
- `vim.opt.winborder = "rounded"` を追加（ホバー / フロートの枠を角丸に、Neovim 0.11+）
- WSL クリップボードを `win32yank` 方式に変更（旧: paste ごとに `powershell.exe` を起動していて遅かった）
- `~/.local/bin` を PATH 先頭に追加（GUI 起動でも `win32yank.exe` を解決できるように）

**`lua/config/keymaps.lua`**（LazyVim 既定と衝突しないもののみ）
- ビジュアルで `<` / `>` のインデント後に選択を維持
- `x` `<leader>p` — レジスタを汚さないペースト（`"_dP`）
- `n` / `N` / `<C-d>` / `<C-u>` — 移動後にカーソルを画面中央へ（検索方向の正規化は維持）
- `n` `<Esc>` — 検索ハイライトも消す
- `t` `<Esc><Esc>` — ターミナルモードを抜ける
- `i` `jk` — 挿入モードを抜ける（不要なら該当行を削除）

**`lua/config/autocmds.lua`**
- コメント行の下で `o` / `O` / Enter を押したときにコメントリーダーを自動挿入しない

**プラグイン**
- `lua/plugins/colorscheme.lua`（新規）: tokyonight を `style = "storm"` で設定
- `lua/plugins/ui.lua`（新規）: which-key を `preset = "modern"`、noice のホバーに枠線、
  lualine をファイル相対パス表示
- `lua/plugins/coding.lua`（新規）: Treesitter パーサ追加、Mason の壊れる pip ツール
  （`clang-format` / `cmakelang` / `cmakelint`）を `ensure_installed` から除外

**LazyVim extras（`lazyvim.json`）**
- `lang.clangd` — clangd LSP + clangd_extensions、`<leader>ch` でソース ⇄ ヘッダ切替
- `lang.cmake` — neocmakelsp + cmake-tools.nvim
- `ui.treesitter-context` — スクロール時に関数 / 構造体のヘッダを画面上部に固定表示

**検証済み**
- `.cpp` を開くと clangd が接続、LSP 整形が動作、`<leader>ch` でヘッダ切替
- `CMakeLists.txt` を開くと neocmake が接続、cmakelint エラーなし
- クリップボード provider が `win32yank-wsl`、レジスタ往復 OK
- which-key(modern) / lualine / treesitter-context / tokyonight-storm すべて読込 OK
