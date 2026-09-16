local wezterm = require("wezterm")

local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_lower_right_triangle
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle

-- タブに表示する名前
--   1. LEADER+, で付けた名前があればそれ
--   2. なければカレントディレクトリ名
--   3. それも取れなければ pane のタイトル
local function tab_label(tab)
  if tab.tab_title and #tab.tab_title > 0 then
    return tab.tab_title
  end
  local cwd = tab.active_pane.current_working_dir
  if cwd then
    -- Url オブジェクト (20240203 以降) / 文字列の両方に対応
    local path = type(cwd) == "userdata" and cwd.file_path or tostring(cwd)
    path = path:gsub("[/\\]+$", "")
    local base = path:match("([^/\\]+)$")
    if base and #base > 0 then
      return base
    end
  end
  return tab.active_pane.title
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local tab_bg = "#5c6d74"
  local tab_fg = "#FFFFFF"
  local edge_bg = "none"
  if tab.is_active then
    tab_bg = "#ae8b2d"
    tab_fg = "#FFFFFF"
  end
  local edge_fg = tab_bg
  -- 番号は ALT+数字 に対応
  local label = string.format("%d: %s", tab.tab_index + 1, tab_label(tab))
  local title = "  " .. wezterm.truncate_right(label, max_width - 4) .. "  "
  return {
    { Background = { Color = edge_bg } },
    { Foreground = { Color = edge_fg } },
    { Text = SOLID_LEFT_ARROW },
    { Background = { Color = tab_bg } },
    { Foreground = { Color = tab_fg } },
    { Text = title },
    { Background = { Color = edge_bg } },
    { Foreground = { Color = edge_fg } },
    { Text = SOLID_RIGHT_ARROW },
  }
end)
