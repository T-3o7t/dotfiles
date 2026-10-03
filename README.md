# dotfiles

```sh
git clone git@github.com:T-3o7t/dotfiles.git ~/github/dotfiles
~/github/dotfiles/install.sh
```

`install.sh` はホーム直下の dotfile と `~/.config/nvim`, `~/.config/wezterm` をこのリポジトリへのシンボリックリンクにします。
WSL 上で実行した場合は、Windows 側の WezTerm が読む `%USERPROFILE%\.config\wezterm` にもコピーします(設定を変えたら再度 `install.sh` を実行して反映)。

## wezterm

| ファイル | 役割 |
|---|---|
| `wezterm.lua` | 本体。フォント・見た目・Windows 固有設定 (WSL 既定起動など) |
| `keybinds.lua` | キーバインド。LEADER は `CTRL+Space`。検索 `CTRL+SHIFT+F` / `LEADER+/`、QuickSelect `LEADER+Space`、URL を開く `LEADER+u` |
| `tabbar.lua` | タブ表示 (`番号: ディレクトリ名`) |
| `status.lua` | 右ステータス (LEADER / キーテーブル / workspace / 時刻) |
| `palette.lua` | 現在のカラースキームからタブ・ステータスの色を取り出す |
| `layout.lua` | pane の自動等分 (分割時・閉じた時) と `LEADER+=` |
| `colorscheme.lua` | `LEADER+c` / `LEADER+C` でのカラースキーム切替 (選択は `.colorscheme` に保存) |
| `background.lua` | `LEADER+b` での背景画像切替 (`images/` 内の画像 or なし。選択は `.background` に保存。nvim 起動中は画像を消す) |
| `images/` | 背景画像 (jpg/png/gif/webp/bmp を置くと `LEADER+b` の一覧に出る) |

### 操作方法 (検索 / QuickSelect / URL / 表示)

LEADER = `CTRL+Space` を押して離してから、2 秒以内に次のキーを押す。

#### スクロールバック検索

| キー | 動作 |
|---|---|
| `CTRL+SHIFT+F` / `LEADER` → `/` | 検索を開始 (文字を打つと一致箇所がハイライトされる) |
| `CTRL+n` / `↓` | 次の一致へ |
| `CTRL+p` / `↑` / `Enter` | 前の一致へ |
| `PageDown` / `PageUp` | 1 ページ先 / 前の一致へ |
| `CTRL+r` | 大文字小文字を区別 → 無視 → 正規表現 を順に切替 |
| `CTRL+u` | 入力した検索語を消す |
| `Escape` | 検索を終了 |

コピーモード (`LEADER` → `[`) の中では `/` で検索開始、`n` / `N` で次 / 前の一致へ移動、`v` で選択して `y` でコピー。

| キー | 動作 |
|---|---|
| `SHIFT+PageUp` / `SHIFT+PageDown` | 1 ページ上 / 下へスクロール |

#### QuickSelect / URL を開く

| キー | 動作 |
|---|---|
| `LEADER` → `Space` | 画面上のハッシュ・パス・URL・数字などに英字ラベルが付く。ラベルを打つとその文字列をクリップボードへコピー (`Escape` で中止) |
| `LEADER` → `u` | 画面上の URL だけにラベルが付く。ラベルを打つとブラウザで開く |
| `CTRL` + 左クリック | マウス下の URL をブラウザで開く (普通のクリックでは開かない) |

QuickSelect でラベルを大文字で打つと、コピーに加えて貼り付けも行う。

#### 右ステータスとタブの表示

- 右ステータス: `[LEADER] [TABLE: 名前]  ws: workspace | バッテリー | 日時`
  - `LEADER` バッジは `CTRL+Space` を押して次のキーを待っている間だけ表示される
  - `TABLE` バッジは `LEADER+s` (pane サイズ調整) などのキーテーブルが有効な間だけ表示される
- タブとステータスの色は、現在のカラースキームの色から自動で決まる。`LEADER` → `c` (お気に入り) / `LEADER` → `C` (全スキーム) でテーマを変えると一緒に変わる
- 背景画像は `LEADER` → `b` で `images/` 内の画像か「(なし)」を選ぶ。選択は保存され、次回起動時も維持される

nvim との `CTRL+h/j/k/l` pane 移動連携には `nvim/lua/plugins/smart-splits.lua` が必要。
WSL では `wezterm` コマンドが PATH にある必要がある: `ln -s "/mnt/c/Program Files/WezTerm/wezterm.exe" ~/.local/bin/wezterm`
