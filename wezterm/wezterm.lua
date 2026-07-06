-- Pull in the wezterm API
local wezterm = require 'wezterm'
local background = require 'background' 

-- This will hold the configuration.
local config = wezterm.config_builder()
config.automatically_reload_config = true
config.font_size = 12.0
config.use_ime = true
config.window_background_opacity = 0.1
config.win32_system_backdrop = 'Mica'
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.window_frame = {
  inactive_titlebar_bg = "none",
  active_titlebar_bg = "none",
}
config.window_background_gradient = {
  colors = { "#000000" },
}
config.show_new_tab_button_in_tab_bar = false
--config.show_close_tab_button_in_tabs = false
config.colors = {
   tab_bar = {
   inactive_tab_edge = "none",
  },
}

local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_lower_right_triangle
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
local background = "#5c6d74"
local foreground = "#FFFFFF"
local edge_background = "none"

 if tab.is_active then
    background = "#ae8b2d"
    foreground = "#FFFFFF"
end

  local title = "   " .. wezterm.truncate_right(tab.active_pane.title, max_width - 1) .. "   "

  return {
      { Background = { Color = edge_background } },
      { Text = SOLID_LEFT_ARROW },
      { Background = { Color = background } },
      { Foreground = { Color = foreground } },
      { Text = title },
      { Background = { Color = edge_background } },
      { Text = SOLID_RIGHT_ARROW },
  }
end)


-- This is where you actually apply your config choices
config.color_scheme = 'AdventureTime'
config.background = background

-- and finally, return the configuration to wezterm
return config
