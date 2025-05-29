-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.

local function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return "Catppuccin Mocha"
	else
		return "Catppuccin Latte"
	end
end
-- For example, changing the initial geometry for new windows:
config.initial_cols = 200
config.initial_rows = 80

config.window_background_opacity = 0.98

-- or, changing the font size and color scheme.
config.font_size = 10
config.font = wezterm.font("Maple Mono NF", {})
config.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance())

-- Finally, return the configuration to wezterm:
return config
