return {
  -- nvim の分割ウィンドウと WezTerm の pane を <C-h/j/k/l> でシームレスに移動
  -- WezTerm 側: ~/.config/wezterm/keybinds.lua の nav_key() が対応
  -- 端に到達すると `wezterm cli activate-pane-direction` で WezTerm 側の pane へ移る
  --   → wezterm が WSL の $PATH に必要 (~/.local/bin/wezterm -> wezterm.exe)
  --   → $WEZTERM_PANE が必要 (wezterm.lua の WSLENV 設定で受け渡し)
  {
    "mrjones2014/smart-splits.nvim",
    lazy = false, -- 起動時に IS_NVIM user var を WezTerm へ送るため遅延読込しない
    opts = {
      multiplexer_integration = "wezterm",
      at_edge = "wrap", -- WezTerm 側に pane が無ければ nvim 内で折り返す
    },
    keys = {
      { "<C-h>", function() require("smart-splits").move_cursor_left() end, desc = "Go to left window/pane" },
      { "<C-j>", function() require("smart-splits").move_cursor_down() end, desc = "Go to lower window/pane" },
      { "<C-k>", function() require("smart-splits").move_cursor_up() end, desc = "Go to upper window/pane" },
      { "<C-l>", function() require("smart-splits").move_cursor_right() end, desc = "Go to right window/pane" },
    },
  },
}
