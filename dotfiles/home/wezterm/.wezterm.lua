-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = "Catppuccin Mocha"

config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 12

config.enable_tab_bar = false

config.window_background_opacity = 0.75
config.macos_window_background_blur = 8

config.enable_wayland = true
config.window_decorations = "NONE"
-- and finally, return the configuration to wezterm
return config
