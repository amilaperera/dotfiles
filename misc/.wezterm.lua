-- Pull in the wezterm API
local wezterm = require("wezterm")

local launch_menu = {}

-- This will hold the configuration.
local config = wezterm.config_builder()
-- This is where you actually apply your config choices.
config.launch_menu = launch_menu

-- For example, changing the initial geometry for new windows:
config.initial_cols = 130
config.initial_rows = 50

if wezterm.target_triple:find("windows") then
	config.default_domain = "WSL:Ubuntu"
else
	config.default_domain = "local"
end

config.font = wezterm.font("FiraCode Nerd Font")
config.font_size = 10
config.color_scheme = "Konsolas"

config.window_background_opacity = 0.9
config.window_decorations = "RESIZE"

config.colors = {
	cursor_bg = "white",
}
config.default_cursor_style = "SteadyBlock"

local mux = wezterm.mux

wezterm.on("gui-startup", function()
	local tab, pane, window = mux.spawn_window({})
	window:gui_window():maximize()
end)

-- Finally, return the configuration to wezterm:
return config
