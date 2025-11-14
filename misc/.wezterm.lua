-- Pull in the wezterm API
local wezterm = require("wezterm")

local launch_menu = {}

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.
config.launch_menu = launch_menu

-- For example, changing the initial geometry for new windows:
if wezterm.target_triple:find("windows") then
	config.default_domain = "WSL:Ubuntu"
	config.font = wezterm.font("FiraCode Nerd Font")
	config.font_size = 10
	config.color_scheme = "Konsolas"
else
	config.font = wezterm.font("Hack Nerd Font")
	config.font_size = 10
	config.default_domain = "local"
	config.color_scheme = "Catppuccin Mocha"
end

config.window_background_opacity = 0.9

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
