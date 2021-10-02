local wezterm = require("wezterm")

return {
	font = wezterm.font("APL386 Unicode"),
	font_size = 20,
	window_padding = {
		left = 16,
		right = 16,
		top = 0,
		bottom = 8,
	},
	bold_brightens_ansi_colors = false,
-- 	color_scheme = "Dracula",
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
}
