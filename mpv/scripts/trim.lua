-- trim video without re-encoding
-- press t to set start point, press t again at end point to trim

local start_pos = nil

local function print(s)
	mp.msg.info(s)
	mp.osd_message(s)
end

function timestamp(duration)

	local hours = duration / 3600
	local minutes = duration % 3600 / 60
	local seconds = duration % 60

	return string.format("%02d:%02d:%02d", hours, minutes, seconds)

end

function escape(str)
	return str:gsub("([^%w])", "%%%1")
end

function cut(p1, p2)

	local fname = mp.get_property("filename")
	local basename = mp.get_property("filename/no-ext")
	local src_path = mp.get_property("path")
	local t1 = timestamp(p1)
	local t2 = timestamp(p2)
	local out_path = src_path:gsub(escape(fname), string.format("%s (%s-%s).mp4", basename, t1, t2))

	print("Trimming...")

	local res = mp.command_native_async({
		name = "subprocess",
		args = {
			"/opt/homebrew/bin/ffmpeg",
			"-i", src_path,
			"-ss", t1,
			"-to", t2,
			"-avoid_negative_ts", "make_zero",
			"-c", "copy",
			"-y",
			out_path
		},
		playback_only = false,
	}, function()
		print("Trimmed: " .. out_path)
	end)

end

function mark()

	local pos = mp.get_property_number("time-pos")

	if not start_pos then
		print("Trim point start: " .. timestamp(pos))
		start_pos = pos
	else
		cut(start_pos, pos)
		start_pos = nil
	end

end

mp.add_forced_key_binding("t", "trim", mark)
