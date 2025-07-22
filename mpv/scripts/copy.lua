-- copy path / name to clipboard

function print(s)
	mp.msg.info(s)
	mp.osd_message(s)
end

-- TODO: not copying correct non ascii characters
function copy()
	local path = mp.get_property("path")
	local pipe = io.popen("pbcopy", "w")
	pipe:write(path .. "")
	pipe:close()
	print(path)
end

mp.add_forced_key_binding("y", "copy-path", copy)
