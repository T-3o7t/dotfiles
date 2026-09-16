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
| `keybinds.lua` | キーバインド。LEADER は `CTRL+Space` |
| `tabbar.lua` | タブ表示 (`番号: ディレクトリ名`) |
| `status.lua` | 右ステータス (キーテーブル / workspace / 時刻) |
| `layout.lua` | pane の自動等分 (分割時・閉じた時) と `LEADER+=` |
| `colorscheme.lua` | `LEADER+c` / `LEADER+C` でのカラースキーム切替 (選択は `.colorscheme` に保存) |
| `background.lua` | 背景画像 (既定では無効。`wezterm.lua` の require のコメントを外して有効化) |
| `images/` | 背景画像 |

nvim との `CTRL+h/j/k/l` pane 移動連携には `nvim/lua/plugins/smart-splits.lua` が必要。
WSL では `wezterm` コマンドが PATH にある必要がある: `ln -s "/mnt/c/Program Files/WezTerm/wezterm.exe" ~/.local/bin/wezterm`
