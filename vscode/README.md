# vscode

Windows の VS Code から Remote-WSL で WSL に接続し、WSL の Neovim（`../nvim`）を vscode-neovim 経由で使う構成。
LaTeX は WSL の TeX Live（upLaTeX + latexmk）を LaTeX Workshop から使う。

| ファイル | 役割 |
|---|---|
| `settings.json` | ユーザー設定（`%APPDATA%\Code\User\settings.json`）。WSL 接続時にも適用される |
| `extensions-windows.txt` | Windows 側（UI）に入れる拡張機能 |
| `extensions-wsl.txt` | WSL 側（Remote-WSL サーバ）に入れる拡張機能 |

`../install.sh` を WSL で実行すると、`settings.json` を Windows 側へコピーし（既存のものは `settings.json.bak` に退避）、拡張機能を導入する。
Windows のプログラムは WSL 内のシンボリックリンクを辿れないのでコピーで反映する。
VS Code の設定 UI で変えた場合は `%APPDATA%\Code\User\settings.json` をこのディレクトリへコピーし直してコミットする。

## nvim との対応

- nvim の `init.lua` は `vim.g.vscode` のとき lazy.nvim のプラグインを読まず、`lua/config/vscode.lua` を読む
  - `options.lua` / `keymaps.lua` / `autocmds.lua` は共通（`n`/`N` の中央寄せ、`<leader>p`、`:W` などの別名、yank ハイライト）
  - win32yank のクリップボード設定は VS Code では使わない（VS Code のクリップボードを使う）
- `lua/config/vscode.lua` で nvim と同じキーを VS Code のコマンドに割り当てている

| キー | nvim | VS Code |
|---|---|---|
| `<C-h/j/k/l>` | smart-splits | エディタグループ / パネル移動 |
| `<S-h>` / `<S-l>` / `<leader>bd` | バッファ切替 / 削除 | タブ切替 / 閉じる |
| `<leader>ff` `<leader><space>` / `fg` `<leader>/` / `fb` / `fr` / `fd` | telescope | クイックオープン / 全体検索 / 開いているエディタ / 最近開いた項目 / 問題パネル |
| `<leader>e` / `<leader>E` / `-` | nvim-tree / oil | サイドバー開閉 / エクスプローラで現在のファイルを表示 |
| `gd` / `K` | LSP | vscode-neovim 既定（定義へ移動 / ホバー） |
| `gr` / `gI` / `<leader>ca` `cr` `cf` `cd` `cs` / `]d` `[d` | LSP | 参照 / 実装 / クイックフィックス・名前変更・整形・ホバー・シンボル / 次・前の問題 |
| `]c` `[c` / `<leader>gp` `gb` `gr` | gitsigns | 次・前の変更 / 差分表示・blame・変更を戻す |
| `<leader>tt` | 右分割ターミナル | 統合ターミナル |
| `<leader>ut` `<leader>uC` | カラースキーム切替 | テーマ選択 |
| `jk`（挿入モード） | `keymaps.lua` | `vscode-neovim.compositeKeys`（挿入モードは VS Code が処理するため） |

`settings.json` 側で揃えているもの:

- インデント 4・スペース、相対行番号、`scrolloff` 4 相当（`cursorSurroundingLines`）、折り返しなし、smartcase、LF / UTF-8
- treesitter-context 相当のスティッキースクロール（最大 3 行）
- テーマ Catppuccin Mocha（nvim と同じ。Tokyo Night も導入済み）、フォントは WezTerm と同じ JetBrains Mono → BIZ UDゴシック
  - JetBrains Mono と Symbols Nerd Font Mono は Windows に手動でインストールする
- clangd / stylua は nvim の Mason で入れたもの（`~/.local/share/nvim/mason/bin`）を同じ引数で使う
- diagnostic の virtual_text 相当として Error Lens

## LaTeX

- `../.latexmkrc`（`install.sh` で `~/.latexmkrc` にリンク）: upLaTeX → upbibtex → dvipdfmx
  - LaTeX Workshop は `latexmk -outdir=out` で実行するので、`$dvipdf` に `-o %D` が必要（無いと PDF が `out/` に出ず失敗する）
- LaTeX Workshop の生成物は `out/` に出る。プレビューは `Ctrl+Alt+V`
- bxjsarticle を使う場合、クラスオプションは `dvipdfmx` にする（古い `dvipdfmx-if-dvi` では xcolor が dvips 用ドライバを読み、PNG が PDF に入らない）
