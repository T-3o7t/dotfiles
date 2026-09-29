local wezterm = require("wezterm")
local palette = require("palette")

-- 右ステータス: [LEADER] [TABLE: xxx]  ws: name | battery | YYYY-MM-DD HH:MM
-- 色は現在のカラースキームに合わせる (palette.lua)
wezterm.on("update-status", function(window, pane)
  local c = palette.get(window:effective_config().color_scheme)
  local elements = {}

  -- LEADER 待機中 / キーテーブル有効中は目立つバッジで表示
  local badges = {}
  if window:leader_is_active() then
    table.insert(badges, { text = "LEADER", bg = c.red })
  end
  local key_table = window:active_key_table()
  if key_table then
    table.insert(badges, { text = "TABLE: " .. key_table, bg = c.accent })
  end
  for _, b in ipairs(badges) do
    table.insert(elements, { Background = { Color = b.bg } })
    table.insert(elements, { Foreground = { Color = c.bg } })
    table.insert(elements, { Text = " " .. b.text .. " " })
    table.insert(elements, "ResetAttributes")
    table.insert(elements, { Text = " " })
  end

  local cells = {}

  table.insert(cells, { text = "ws: " .. window:active_workspace(), fg = c.cyan })

  -- バッテリー (ノート PC のみ。デスクトップでは空になる)
  for _, b in ipairs(wezterm.battery_info()) do
    table.insert(cells, { text = string.format("%.0f%%", b.state_of_charge * 100), fg = c.green })
  end

  table.insert(cells, { text = wezterm.strftime("%Y-%m-%d %H:%M"), fg = c.fg })

  for i, cell in ipairs(cells) do
    table.insert(elements, { Foreground = { Color = cell.fg } })
    table.insert(elements, { Text = " " .. cell.text .. " " })
    if i < #cells then
      table.insert(elements, { Foreground = { Color = c.muted } })
      table.insert(elements, { Text = "|" })
    end
  end
  window:set_right_status(wezterm.format(elements))
end)
