local wezterm = require("wezterm")

-- 背景画像のパス (images/ 配下から選ぶ)
-- 候補: bg_zan.jpg (縦長) / bg_zan2.jpg (横長) / bg_dq.jpg
local background_image = wezterm.config_dir .. "/images/bg_zan2.jpg"

local gradient_layer = {
  source = {
    Gradient = {
      colors = { "#000000", "#FFFFFF" },
      orientation = {
        Linear = {
          angle = -30.0,
        },
      },
    },
  },
  opacity = 0.35,
  width = "100%",
  height = "100%",
}

local image_layer = {
  source = { File = background_image },
  opacity = 0.12,
  vertical_align = "Middle",
  horizontal_align = "Center",
  repeat_x = "NoRepeat",
  repeat_y = "NoRepeat",
  -- 比率を維持したままウィンドウ全体を覆う
  width = "Cover",
  height = "Cover",
}

-- デフォルトのbackground
local default_bg = {
  gradient_layer,
  image_layer,
}

-- Neovim使用時のbackground
local neovim_bg = {
  gradient_layer,
}

local prev_process_name
local prev_background

wezterm.on("update-status", function(window, pane)
  -- フォアグラウンドプロセスの名前を取得 (mux/remote pane では nil になりうる)
  local process_name = pane:get_foreground_process_name()

  -- 前のプロセス名と同じであればなにもしない
  if process_name == prev_process_name then
    return
  end

  -- プロセス名にnvimが含まれているか判定
  local new_background = (process_name and process_name:find("nvim")) and neovim_bg or nil

  -- 現在のbackgroundと異なればconfig.backgroundをオーバーライドする
  if new_background ~= prev_background then
    local overrides = window:get_config_overrides() or {}
    overrides.background = new_background
    window:set_config_overrides(overrides)
    prev_background = new_background
  end

  prev_process_name = process_name
end)

return default_bg
