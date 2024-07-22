-- open in finder / wezterm
-- alt+= open current directory finder
-- alt+- open current directory in wezterm

local utils = require("mp.utils")

function open_finder()
	local path = mp.get_property("path")
	local dir, filename = utils.split_path(path)
	mp.command_native_async({
		name = "subprocess",
		args = { "open", dir },
		playback_only = false,
	})
end

function open_wezterm()
	local path = mp.get_property("path")
	local dir, filename = utils.split_path(path)
	mp.command_native_async({
		name = "subprocess",
		args = { "/opt/homebrew/bin/wezterm", "cli", "spawn", "--cwd", dir },
		playback_only = false,
	})
end

mp.add_key_binding("alt+=", "openinfinder", open_finder)
mp.add_key_binding("alt+-", "openinwezterm", open_wezterm)
