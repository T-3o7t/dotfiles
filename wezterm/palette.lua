local wezterm = require("wezterm")

local M = {}

-- スキームが取れないときの色 (以前の固定色)
local fallback = {
  bg = "#1a1b26",
  fg = "#d8dee9",
  accent = "#ae8b2d",
  muted = "#5c6d74",
  red = "#bf616a",
  green = "#a3be8c",
  blue = "#81a1c1",
  magenta = "#b48ead",
  cyan = "#8fbcbb",
}

local cache = {}

-- カラースキーム名から tabbar / status で使う色を取り出す
function M.get(scheme_name)
  if scheme_name and cache[scheme_name] then
    return cache[scheme_name]
  end

  local s = scheme_name and wezterm.get_builtin_color_schemes()[scheme_name]
  local ansi = (s and s.ansi) or {}
  local brights = (s and s.brights) or {}
  local p = {
    bg = (s and s.background) or fallback.bg,
    fg = (s and s.foreground) or fallback.fg,
    accent = ansi[4] or fallback.accent, -- yellow
    muted = brights[1] or fallback.muted, -- bright black
    red = ansi[2] or fallback.red,
    green = ansi[3] or fallback.green,
    blue = ansi[5] or fallback.blue,
    magenta = ansi[6] or fallback.magenta,
    cyan = ansi[7] or fallback.cyan,
  }

  if scheme_name then
    cache[scheme_name] = p
  end
  return p
end

return M
