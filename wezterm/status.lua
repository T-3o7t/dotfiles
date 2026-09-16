local wezterm = require("wezterm")

-- 右ステータス: [TABLE: xxx]  ws: name  |  battery  |  YYYY-MM-DD HH:MM
wezterm.on("update-status", function(window, pane)
  local cells = {}

  local key_table = window:active_key_table()
  if key_table then
    table.insert(cells, { text = "TABLE: " .. key_table, fg = "#ae8b2d" })
  end

  table.insert(cells, { text = "ws: " .. window:active_workspace(), fg = "#8fbcbb" })

  -- バッテリー (ノート PC のみ。デスクトップでは空になる)
  for _, b in ipairs(wezterm.battery_info()) do
    table.insert(cells, { text = string.format("%.0f%%", b.state_of_charge * 100), fg = "#a3be8c" })
  end

  table.insert(cells, { text = wezterm.strftime("%Y-%m-%d %H:%M"), fg = "#d8dee9" })

  local elements = {}
  for i, c in ipairs(cells) do
    table.insert(elements, { Foreground = { Color = c.fg } })
    table.insert(elements, { Text = " " .. c.text .. " " })
    if i < #cells then
      table.insert(elements, { Foreground = { Color = "#5c6d74" } })
      table.insert(elements, { Text = "|" })
    end
  end
  window:set_right_status(wezterm.format(elements))
end)
