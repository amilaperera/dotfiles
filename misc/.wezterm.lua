-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- platform specific settings
if wezterm.target_triple:find("windows") then
    config.default_domain = "WSL:Ubuntu"
    config.font = wezterm.font("FiraCode Nerd Font")
    config.font_size = 10
    config.color_scheme = "Konsolas"
else
    config.font = wezterm.font("Hack Nerd Font")
    config.font_size = 10
    config.default_domain = "local"
    config.color_scheme = "nightfox"
end

-- window settings
config.window_decorations = "RESIZE"
config.window_padding = {
    left = 5,
    right = 5,
    top = 0,
    bottom = 0,
}

-- maximize window on startup
local mux = wezterm.mux
wezterm.on("gui-startup", function()
    local tab, pane, window = mux.spawn_window({})
    window:gui_window():maximize()
end)

-- cursor settings
config.default_cursor_style = "SteadyBlock"
config.colors = {
    cursor_bg = "white",
}

-- tab bar settings
config.use_fancy_tab_bar = false

-- Finally, return the configuration to wezterm:
return config
