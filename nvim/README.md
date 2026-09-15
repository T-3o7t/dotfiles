# Neovim config (lazy.nvim 自前構成)

WSL + wezterm 上で使う Neovim 設定。プラグインマネージャ [lazy.nvim](https://github.com/folke/lazy.nvim) に
必要なプラグインだけを自分で列挙した構成（以前は LazyVim ベースだったが 2026-09-15 に脱却）。
Neovim 0.11+ 前提（`vim.lsp.config` / `winborder` / `vim.hl.on_yank` を使用。現在 0.12 で動作確認）。

## 構成

| パス | 役割 |
|---|---|
| `init.lua` | leader 設定と `config.*` の読み込み |
| `lua/config/options.lua` | オプション（WSL クリップボード、インデント、外観、PATH など） |
| `lua/config/keymaps.lua` | プラグインに依存しないキーマップと `:W` 系コマンド別名 |
| `lua/config/autocmds.lua` | yank ハイライト / カーソル位置復元 / 保存時 mkdir / formatoptions |
| `lua/config/lazy.lua` | lazy.nvim ブートストラップと `setup()` |
| `lua/plugins/colorscheme.lua` | tokyonight（storm） |
| `lua/plugins/ui.lua` | lualine / which-key / mini.icons |
| `lua/plugins/treesitter.lua` | nvim-treesitter（main ブランチ）/ treesitter-context |
| `lua/plugins/lsp.lua` | mason / mason-lspconfig / nvim-lspconfig / lazydev、LSP キーマップ |
| `lua/plugins/completion.lua` | blink.cmp |
| `lua/plugins/telescope.lua` | telescope（ファイル / grep / バッファ検索） |
| `lua/plugins/git.lua` | gitsigns |
| `colors/tender.vim` | 旧 vim から移植したカラースキーム（`:colorscheme tender` で切替） |
| `lazy-lock.json` | プラグインのバージョン固定 |

## プラグイン（12 個）

| プラグイン | 役割 | 読込タイミング |
|---|---|---|
| tokyonight.nvim | カラースキーム | 起動時 |
| nvim-treesitter (+context) | シンタックスハイライト・インデント・関数ヘッダ固定表示 | 起動時 / VeryLazy |
| mason.nvim / mason-lspconfig.nvim | LSP サーバの導入と自動有効化（clangd / neocmakelsp / lua_ls） | `:Mason` / ファイル読込時 |
| nvim-lspconfig | 各 LSP サーバの既定設定 | ファイル読込時 |
| lazydev.nvim | nvim 設定編集時の `vim.*` 補完 | Lua ファイル |
| blink.cmp | 補完（`<CR>` 確定、`<C-n>/<C-p>` 選択） | 挿入モード |
| telescope.nvim (+plenary) | ファジーファインダ | キー押下時 |
| lualine.nvim (+mini.icons) | ステータスライン（相対パス表示） | VeryLazy |
| which-key.nvim | `<leader>` 後のキー候補表示 | VeryLazy |
| gitsigns.nvim | git 差分サイン・hunk 操作 | ファイル読込時 |

## 主なキーマップ（leader = Space）

| キー | 動作 | 定義場所 |
|---|---|---|
| `<C-h/j/k/l>` | ウィンドウ移動 | keymaps.lua |
| `<S-h>` / `<S-l>` / `<leader>bd` | 前 / 次のバッファ / バッファを閉じる | keymaps.lua |
| `<A-j>` / `<A-k>` | 行（選択範囲）を上下に移動 | keymaps.lua |
| `<C-s>` | 保存 | keymaps.lua |
| `jk` / `<Esc>` | 挿入モード脱出 / 検索ハイライト消去 | keymaps.lua |
| `<leader>p`（visual） | レジスタを汚さないペースト | keymaps.lua |
| `<leader>l` | `:Lazy` | keymaps.lua |
| `<leader>ff` `<leader><space>` | ファイル検索 | telescope.lua |
| `<leader>fg` `<leader>/` | grep（ripgrep 必要） | telescope.lua |
| `<leader>fb` / `fr` / `fh` / `fd` | バッファ / 最近のファイル / ヘルプ / 診断 | telescope.lua |
| `gd` / `gr` / `gI` / `<leader>cs` | 定義 / 参照 / 実装 / シンボル（telescope） | lsp.lua |
| `<leader>ca` / `cr` / `cf` / `cd` | コードアクション / リネーム / 整形 / 行の診断 | lsp.lua |
| `K` / `]d` `[d` | ホバー / 診断移動（Neovim 組込） | — |
| `]c` `[c` / `<leader>gp` `gb` `gr` | hunk 移動 / プレビュー / blame / リセット | git.lua |

## 依存（設定リポジトリ外）

| ツール | 用途 | 入手方法 |
|---|---|---|
| `win32yank.exe` | WSL クリップボード連携 | Windows 側 Neovim 同梱（`C:\Program Files\Neovim\bin`）が WSL の PATH に乗っていれば追加導入不要 |
| `ripgrep` (`rg`) | telescope の live grep | `sudo apt install ripgrep` |
| C コンパイラ (`gcc`) | Treesitter パーサのビルド | 導入済み |
| `clangd` / `neocmakelsp` / `lua-language-server` / `tree-sitter` | LSP と Treesitter CLI | Mason が自動導入（`~/.local/share/nvim/mason/bin`。options.lua で PATH に追加済み） |

## メモ

- C/C++ のクロスファイル補完・診断をフルに使うにはプロジェクト直下に `compile_commands.json`
  （CMake: `-DCMAKE_EXPORT_COMPILE_COMMANDS=1`、または `bear -- make`）か `.clangd` が必要。
- 整形は clangd（C/C++）・neocmakelsp（CMake）・stylua（Lua、Mason 導入済みで LSP モード動作）が LSP 経由で担当。
  `<leader>cf` で手動実行。保存時の自動整形は無し。
- nvim-treesitter は main ブランチ。対象言語は `lua/plugins/treesitter.lua` の `languages` に追加する
  （旧 master の `ensure_installed` は無い）。
- `~/.config/nvim` の実体は `~/github/dotfiles/nvim` と同期している（rsync）。symlink ではない。
- 旧 LazyVim 構成は `~/.config/nvim.lazyvim-backup` に退避（`~/.config/nvim_org` は更に古い初期スターター）。

---

## 変更履歴

**記法:** 変更したら `### YYYY-MM-DD — 概要` の見出しを **この行のすぐ下（新しいものが上）** に追加し、
変更点を箇条書きで書く。関連するファイル名を添える。

### 2026-09-15 — LazyVim を外し自前 lazy.nvim 構成へ

LazyVim（35 プラグイン、既定キーマップ多数）がブラックボックスで使いづらかったため、
lazy.nvim に必要なプラグイン 12 個だけを列挙する構成に作り直した。

- `init.lua`: `config.keymaps` / `config.autocmds` を明示的に require（LazyVim の VeryLazy 自動読込に依存しない）
- `lua/config/lazy.lua`: `LazyVim/LazyVim` の import を削除。`rocks.enabled = false`
- `lua/config/options.lua`: LazyVim が設定していた既定のうち必要なものを移植
  （`clipboard=unnamedplus` `undofile` `cursorline` `scrolloff` `splitright/below` `timeoutlen=300` 等）。
  Mason の bin ディレクトリを PATH に追加（mason.nvim を遅延読込にしても clangd / tree-sitter が解決できるように）
- `lua/config/keymaps.lua`: LazyVim 既定から `<C-hjkl>` `<S-h>/<S-l>` `<A-j>/<A-k>` `<C-s>` を移植。
  `]q/[q` `<leader>ch` 等その他の LazyVim 既定キーは引き継がない
- `lua/config/autocmds.lua`: LazyVim が担っていた yank ハイライト / カーソル位置復元 / 保存時 mkdir を移植
- `lua/plugins/`: `coding.lua` を削除し `treesitter.lua` `lsp.lua` `completion.lua` `telescope.lua` `git.lua` を新規作成。
  `colorscheme.lua` から `LazyVim` の opts 行を削除、`ui.lua` から noice を削除し mini.icons を追加
- 削除: `lazyvim.json` `.neoconf.json`（LazyVim / neoconf 専用）
- 入れなかったもの: snacks, noice, flash, mini.pairs, mini.ai, conform, nvim-lint, bufferline, trouble,
  todo-comments, persistence, grug-far, catppuccin, clangd_extensions, cmake-tools, friendly-snippets 等
- 動作確認（headless）: `.cpp` で clangd、`CMakeLists.txt` で neocmake、`.lua` で lua_ls が attach、
  Treesitter ハイライト / indentexpr 有効、`:checkhealth lazy` エラーなし、起動 約 30 ms

### 2026-09-12 — dotfiles を `~/github/dotfiles` に一本化

これまで `~/dotfiles`（symlink 先・実体だが commit `1e11444` のまま停滞）と `~/github/dotfiles`
（git 管理用・最新）に分裂していたのを解消。

- `~/dotfiles` と `~/github/dotfiles` の内容差分を確認し、実際に使われていた値を
  `~/github/dotfiles` へマージ: `.gitconfig`（`user.name`）、`wezterm/wezterm.lua`
  （独自キーバインド・leader キー入りの版を採用）、`nvim/lazy-lock.json`
- `install.sh`: `DOT_DIRECTORY` を `~/github/dotfiles` に変更。`~/.config/nvim` の symlink 作成も追加
- home 直下の symlink を張り替え: `~/.bashrc` `~/.profile` `~/.gitconfig` `~/.vimrc` `~/.vim`
  `~/.config/nvim` はすべて `~/github/dotfiles` 配下を指すように統一
- `~/.git`（`~/dotfiles/.git` への symlink。home 全体が意図せず git 管理下になっていた原因）を削除
- 旧 `~/dotfiles` は `~/dotfiles.old-backup` に退避（`~/.vim.old-backup` /
  `~/.config/nvim.old-backup` も同様）。動作確認後、不要なら削除してよい
- 動作確認: 新規シェルで `vi`/`vim` alias・`$EDITOR`・`git config user.name`、
  nvim の symlink 経由起動（プラグイン読込・`:W` 系コマンド）を確認済み

### 2026-09-12 — 旧 vi 設定の取り込み・コマンド簡略化

`~/.vimrc`（`colorscheme tender` / `nonumber` / `tabstop=4` / `shiftwidth=4`）の内容を確認し、
nvim 側へ反映。`tabstop=4` 等は元々一致していたため差分なし。

- `colors/tender.vim`（新規）: `~/.vim/colors/tender.vim` を移植。既定は tokyonight-storm を維持し、
  `:colorscheme tender` または `<leader>uC`（カラースキーム picker）で切替可能に
- 行番号表示は現状（`number` + `relativenumber` 表示）を維持（vimrc の `nonumber` には合わせない）
- `lua/config/keymaps.lua`: `:W` `:Q` `:Wq` `:WQ` `:Qa` `:QA` `:Wa` `:WA` `:X` `:Xa` `:XA` —
  Shift 押し忘れ/押しすぎのタイポを許容するコマンド別名を追加（`!` やファイル名引数も動作）
- シェル側（`~/.bashrc`）: `vi` / `vim` を `nvim` の alias にし、`$EDITOR` / `$VISUAL` も `nvim` に設定
  （このファイルは `~/dotfiles` と `~/github/dotfiles` の双方に反映。詳細は「メモ」参照）

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
