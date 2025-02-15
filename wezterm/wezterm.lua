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

local cfg = {}

cfg.font = wezterm.font_with_fallback({
	"ProggySquareTT",
	{ family = "Fusion Pixel 10px Monospaced zh_hans", scale = 0.64 },
})

cfg.font_size = 26
cfg.font_dirs = { "fonts" }
-- cfg.font_locator = "ConfigDirsOnly"
cfg.adjust_window_size_when_changing_font_size = false

cfg.underline_thickness = 3
cfg.cursor_thickness = 3
cfg.initial_cols = 96
cfg.initial_rows = 36
cfg.tab_max_width = 24

cfg.window_padding = {
	left = 16,
	right = 16,
	top = 0,
	bottom = 8,
}

cfg.colors = {
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
	tab_bar = {
		inactive_tab_edge = "none",
		active_tab = {
			bg_color = bg,
			fg_color = "#aaa",
		},
		inactive_tab = {
			bg_color = "none",
			fg_color = "#666",
		},
		new_tab = {
			bg_color = "none",
			fg_color = "#666",
			intensity = "Bold",
		},
		new_tab_hover = {
			bg_color = "none",
			fg_color = "#aaa",
			intensity = "Bold",
		},
	},
}

cfg.bold_brightens_ansi_colors = false

cfg.keys = {
	{ key = "Enter", mods = "ALT", action = wezterm.action.DisableDefaultAssignment },
	{ key = "Enter", mods = "SUPER", action = wezterm.action.ToggleFullScreen },
	{ key = "LeftArrow", mods = "SUPER", action = wezterm.action { ActivateTabRelative = -1 } },
	{ key = "RightArrow", mods = "SUPER", action = wezterm.action { ActivateTabRelative = 1 } },
	{ key = "LeftArrow", mods = "SUPER|SHIFT", action = wezterm.action { MoveTabRelative = -1 } },
	{ key = "RightArrow", mods = "SUPER|SHIFT", action = wezterm.action { MoveTabRelative = 1 } },
}

cfg.mouse_bindings = {
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "NONE",
		action = wezterm.action.OpenLinkAtMouseCursor,
	},
}

cfg.audible_bell = "Disabled"
cfg.native_macos_fullscreen_mode = true
cfg.window_decorations = "INTEGRATED_BUTTONS | RESIZE"
cfg.use_fancy_tab_bar = true
cfg.tab_bar_at_bottom = false
cfg.hide_tab_bar_if_only_one_tab = false

cfg.window_frame = {
	font = cfg.font,
	font_size = 24,
	active_titlebar_bg = "#1a1a1a",
	inactive_titlebar_bg = "#1a1a1a",
}

return cfg
