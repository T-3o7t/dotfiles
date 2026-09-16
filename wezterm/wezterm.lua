-- Pull in the wezterm API
local wezterm = require("wezterm")
local keybind = require("keybinds")
require("tabbar") -- format-tab-title
require("status") -- 右ステータス表示
require("layout").watch_pane_close() -- pane を閉じたら残りを等分

-- 背景画像 (background.lua / images/) を有効にする場合は次の行のコメントを解除
local background = nil
-- background = require("background")

-- This will hold the configuration.
local config = wezterm.config_builder()
config.automatically_reload_config = true

-- Windows 固有の設定
if wezterm.target_triple:find("windows") then
	-- 起動シェル: 既定の WSL ディストリビューションを使う。他は LEADER+n の起動メニューから
	local wsl_domains = wezterm.default_wsl_domains()
	if #wsl_domains > 0 then
		config.default_domain = wsl_domains[1].name
	end
	config.launch_menu = {
		{ label = "PowerShell", args = { "powershell.exe", "-NoLogo" }, domain = { DomainName = "local" } },
		{ label = "cmd", args = { "cmd.exe" }, domain = { DomainName = "local" } },
	}
	-- WSL 側に WEZTERM_PANE を渡す (smart-splits.nvim が `wezterm cli` で pane を特定するのに必要)
	config.set_environment_variables = {
		WSLENV = "WEZTERM_PANE:WEZTERM_UNIX_SOCKET",
	}
end

-- フォント: JetBrains Mono と Nerd Font 記号は WezTerm 同梱。日本語は Noto Sans JP、無ければ順にフォールバック
config.font = wezterm.font_with_fallback({
	"JetBrains Mono",
	{ family = "Noto Sans JP", weight = "DemiLight" },
	"BIZ UDGothic", -- Windows 標準
	"Hiragino Sans", -- macOS 標準
	"Symbols Nerd Font Mono",
})
config.font_size = 12.0
config.use_ime = true

config.window_background_opacity = 0.85
--config.win32_system_backdrop = "Acrylic"
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.scrollback_lines = 10000
config.default_cursor_style = "BlinkingBar"
config.window_close_confirmation = "NeverPrompt"
-- 非アクティブ pane を少し暗くしてフォーカス位置を分かりやすく
config.inactive_pane_hsb = {
	saturation = 0.9,
	brightness = 0.6,
}

config.window_frame = {
	inactive_titlebar_bg = "none",
	active_titlebar_bg = "none",
}
-- 背景無効時のベース色。config.background を有効にするとこちらは無視される
config.window_background_gradient = {
	colors = { "#000000" },
}
config.show_new_tab_button_in_tab_bar = false
config.colors = {
	tab_bar = {
		inactive_tab_edge = "none",
	},
}

config.disable_default_key_bindings = true
config.keys = keybind.keys
config.key_tables = keybind.key_tables
config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 2000 }
-- status.lua の時計 / background.lua の nvim 検知 (update-status) の更新間隔 [ms]
config.status_update_interval = 500
config.background = background

-- カラースキーム: LEADER+c / LEADER+C で切替、選択は .colorscheme に保存される
config.color_scheme = require("colorscheme").load()

-- and finally, return the configuration to wezterm
return config
