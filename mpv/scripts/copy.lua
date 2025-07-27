-- copy path / name to clipboard

function print(s)
	mp.msg.info(s)
	mp.osd_message(s)
end

function copy()
	local path = mp.get_property("path")
	local pipe = io.popen("LANG=en_US.UTF-8 pbcopy", "w")
	pipe:write(path .. "")
	pipe:close()
	print(path)
end

mp.add_forced_key_binding("y", "copy-path", copy)
