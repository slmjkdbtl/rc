local wezterm = require("wezterm")

return {
	font = wezterm.font("APL386 Unicode"),
	font_size = 20,
	initial_cols = 96,
	initial_rows = 30,
	window_padding = {
		left = 16,
		right = 16,
		top = 0,
		bottom = 8,
	},
	colors = {
		foreground = "#dadada",
		background = "#000000",
		cursor_bg = "#eeeeee",
		cursor_border = "#eeeeee",
		selection_bg = "#ffca72",
		selection_fg = "#000000",
		ansi = {
			-- black
			"#666666",
			-- red
			"#ec7580",
			-- green
			"#9ae0a0",
			-- yellow
			"#ffca72",
			-- blue
			"#8abbff",
			-- magenta
			"#f7aad7",
			-- cyan
			"#7ce9df",
			-- white
			"#eeeeee",
		},
	},
	bold_brightens_ansi_colors = false,
	adjust_window_size_when_changing_font_size = false,
	keys = {
		{ key = "Enter", mods = "ALT", action = "DisableDefaultAssignment" },
		{ key = "Enter", mods = "SUPER", action = "ToggleFullScreen" },
		{ key = "LeftArrow", mods = "SUPER", action = wezterm.action { ActivateTabRelative = -1 } },
		{ key = "RightArrow", mods = "SUPER", action = wezterm.action { ActivateTabRelative = 1 } },
		{ key = "LeftArrow", mods = "SUPER|SHIFT", action = wezterm.action { MoveTabRelative = -1 } },
		{ key = "RightArrow", mods = "SUPER|SHIFT", action = wezterm.action { MoveTabRelative = 1 } },
	},
}
