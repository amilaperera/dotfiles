-- The config is minimum as to have wezterm behave as a terminal emulator only.
-- For panes and windows management, use nothing but tmux.

-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- platform identification
local is_windows = wezterm.target_triple:find("windows") ~= nil

-- platform specific settings
if is_windows then
    local launch_menu = {}
    table.insert(launch_menu, {
        label = "PowerShell",
        args = { "powershell.exe" },
    })
    config.launch_menu = launch_menu
end

-- font settings
config.font = wezterm.font("Hack Nerd Font Mono", { weight = "Regular" })

-- Usually font size can stay at 10. If further tweaking is needed, depending on the monitor resolution,
-- put the desired font size (number only) in the file ~/.wezterm_font_size
local function read_file(path)
    local f = io.open(path, "r")
    if not f then
        return nil
    end
    local content = f:read("*a")
    f:close()
    return content
end

local size_string = read_file(wezterm.home_dir .. "/.wezterm_font_size")
local font_size = tonumber(size_string) or 10
config.font_size = font_size

-- colorscheme
config.color_scheme = "Dark+"
-- background image
config.background = {
    {
        source = { File = wezterm.home_dir .. "/.dotfiles/misc/wallpaper2.png" },
        hsb = {
            hue = 1.0,
            saturation = 1.0,
            brightness = 0.02,
        },
    },
}

-- window settings
config.window_decorations = "RESIZE"
config.window_padding = {
    left = 2,
    right = 2,
    top = 0,
    bottom = 2,
}
config.window_close_confirmation = "NeverPrompt"

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

-- scrollback settings
config.scrollback_lines = 20000
config.enable_scroll_bar = false

-- key bindings

-- helpers
local get_btop_cmd = function()
    return is_windows and "C:\\tools\\btop4win\\btop4win.exe" or "btop"
end

-- first the leader
config.leader = { key = "Space", mods = "ALT", timeout_milliseconds = 1000 }

config.keys = {
    { key = "l", mods = "LEADER", action = wezterm.action.ShowLauncher },
    { key = "b", mods = "LEADER", action = wezterm.action.SpawnCommandInNewTab({ args = { get_btop_cmd() } }) },
    {
        key = "w",
        mods = "LEADER",
        action = wezterm.action.SpawnCommandInNewTab({ args = { "wsl.exe", "--cd", "~" } }),
    },
}

-- Finally, return the configuration to wezterm:
return config
