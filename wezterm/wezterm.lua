local wezterm = require("wezterm")

local bg      = "#000000"
local black   = "#666666"
local red     = "#ec7580"
local green   = "#9ae0a0"
local yellow  = "#ffca72"
local blue    = "#8abbff"
local magenta = "#f7aad7"
local cyan    = "#7ce9df"
local white   = "#dadada"

return {
	font = wezterm.font_with_fallback({
		"ProggySquareTT",
		{ family = "Fusion Pixel 10px Monospaced zh_hans", scale = 0.64 },
	}),
	font_size = 24,
	font_dirs = { "fonts" },
	font_locator = "ConfigDirsOnly",
	initial_cols = 96,
	initial_rows = 36,
	tab_max_width = 24,
	window_padding = {
		left = 16,
		right = 16,
		top = 0,
		bottom = 8,
	},
	colors = {
		foreground = white,
		background = bg,
		cursor_bg = white,
		cursor_border = white,
		selection_bg = yellow,
		selection_fg = bg,
		ansi = {
			black,
			red,
			green,
			yellow,
			blue,
			magenta,
			cyan,
			white,
		},
	},
	bold_brightens_ansi_colors = false,
	adjust_window_size_when_changing_font_size = false,
	keys = {
		{ key = "Enter", mods = "ALT", action = wezterm.action.DisableDefaultAssignment },
		{ key = "Enter", mods = "SUPER", action = wezterm.action.ToggleFullScreen },
		{ key = "LeftArrow", mods = "SUPER", action = wezterm.action { ActivateTabRelative = -1 } },
		{ key = "RightArrow", mods = "SUPER", action = wezterm.action { ActivateTabRelative = 1 } },
		{ key = "LeftArrow", mods = "SUPER|SHIFT", action = wezterm.action { MoveTabRelative = -1 } },
		{ key = "RightArrow", mods = "SUPER|SHIFT", action = wezterm.action { MoveTabRelative = 1 } },
	},
	mouse_bindings = {
		{
			event = { Up = { streak = 1, button = "Left" } },
			mods = "NONE",
			action = wezterm.action.OpenLinkAtMouseCursor,
		},
	},
	audible_bell = "Disabled",
	use_fancy_tab_bar = false,
	native_macos_fullscreen_mode = true,
}
