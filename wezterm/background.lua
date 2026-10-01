local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

-- 初期値 (保存ファイルが無いとき)。"none" は背景画像なし
M.default = "none"

-- 選択した画像の保存先 (images/ 配下のファイル名 or "none")
local state_file = wezterm.config_dir .. "/.background"
local image_dir = wezterm.config_dir .. "/images"
local extensions = { jpg = true, jpeg = true, png = true, gif = true, webp = true, bmp = true }

-- images/ 配下の画像ファイル名一覧
-- read_dir は非同期関数で require 中には呼べないため、キー押下時 (action_callback 内) にだけ使う
local function list_images()
  local names = {}
  local ok, paths = pcall(wezterm.read_dir, image_dir)
  if ok then
    for _, p in ipairs(paths) do
      local name = p:match("[^/\\]+$")
      local ext = name and name:match("%.([^.]+)$")
      if ext and extensions[ext:lower()] then
        table.insert(names, name)
      end
    end
  end
  table.sort(names)
  return names
end

local function exists(name)
  local f = io.open(image_dir .. "/" .. name, "rb")
  if f then
    f:close()
    return true
  end
  return false
end

-- 保存されている選択 (画像ファイル名 or "none")
function M.current()
  local f = io.open(state_file, "r")
  if f then
    local name = f:read("*l")
    f:close()
    if name == "none" or (name and #name > 0 and exists(name)) then
      return name
    end
  end
  return M.default
end

local function save(name)
  local f = io.open(state_file, "w")
  if f then
    f:write(name)
    f:close()
  end
end

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

local function image_layer(name)
  return {
    source = { File = image_dir .. "/" .. name },
    opacity = 0.12,
    vertical_align = "Middle",
    horizontal_align = "Center",
    repeat_x = "NoRepeat",
    repeat_y = "NoRepeat",
    -- 比率を維持したままウィンドウ全体を覆う
    width = "Cover",
    height = "Cover",
  }
end

-- 設定読み込み時点の選択 (切替時は reload_configuration で読み直される)
local selected = M.current()

-- Neovim使用時のbackground (画像を消してグラデーションのみ)
local neovim_bg = {
  gradient_layer,
}

-- config.background に渡す値。"none" なら nil (wezterm.lua の window_background_gradient が使われる)
function M.load()
  local name = selected
  if name == "none" then
    return nil
  end
  return { gradient_layer, image_layer(name) }
end

-- nvim がフォアグラウンドの間だけ背景画像を消す (画像なしのときは何もしない)
wezterm.on("update-status", function(window, pane)
  -- フォアグラウンドプロセスの名前を取得 (mux/remote pane では nil になりうる)
  local process_name = pane:get_foreground_process_name()
  local want = selected ~= "none" and process_name ~= nil and process_name:find("nvim") ~= nil

  -- override の有無で判定する (設定再読み込み後も override はウィンドウに残るため)
  local overrides = window:get_config_overrides() or {}
  if want ~= (overrides.background ~= nil) then
    overrides.background = want and neovim_bg or nil
    window:set_config_overrides(overrides)
  end
end)

-- LEADER+b で出す選択肢
local function choices()
  local current = M.current()
  local list = { { id = "none", label = (current == "none" and "* " or "  ") .. "(なし)" } }
  for _, n in ipairs(list_images()) do
    table.insert(list, { id = n, label = (n == current and "* " or "  ") .. n })
  end
  return list
end

function M.pick()
  return wezterm.action_callback(function(window, pane)
    window:perform_action(
      act.InputSelector({
        title = "Background image",
        fuzzy = true,
        choices = choices(),
        action = wezterm.action_callback(function(window, pane, id, label)
          if id then
            save(id)
            -- 保存した名前を wezterm.lua が読み直して全ウィンドウに反映
            wezterm.reload_configuration()
          end
        end),
      }),
      pane
    )
  end)
end

return M
