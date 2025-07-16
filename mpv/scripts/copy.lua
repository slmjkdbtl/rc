-- copy path / name to clipboard
-- TODO: not working?

function print(s)
	mp.msg.info(s)
	mp.osd_message(s)
end

function copy()
	local path = mp.get_property("path")
	print(path)
	mp.command_native_async({
		name = "subprocess",
		args = {
			"pbcopy",
			path
		},
		playback_only = false,
	}, function(success, res, err)
		if success then
			print(path)
		else
			print("failed to copy path")
		end
	end)
end

mp.add_forced_key_binding("alt+y", "copy path", copy)
