-- wengwengweng

local cmd_template = [[ffmpeg -i "$in" -ss $start -to $end -c copy "$out"]]
local start_pos = nil

function msg(str)
	mp.osd_message(str, 3)
end

function timestamp(duration)

	local hours = duration / 3600
	local minutes = duration % 3600 / 60
	local seconds = duration % 60

	return string.format("%02d:%02d:%02d", hours, minutes, seconds)

end

function cut(p1, p2)

	local fname = mp.get_property("filename")
	local basename = mp.get_property("filename/no-ext")
	local path = mp.get_property("path")
	local out_path = path:gsub(fname, string.format("%s_%s-%s.mp4", basename, p1, p2))

	local cmd = cmd_template:gsub("$in", path)
	local cmd = cmd:gsub("$out", out_path)
	local cmd = cmd:gsub("$start", timestamp(p1))
	local cmd = cmd:gsub("$end", timestamp(p2))

	msg("Trimming...")
	os.execute(cmd)
	msg("Trimmed: " .. out_path)

end

function mark()

	local pos = mp.get_property_number("time-pos")

	if not start_pos then
		msg("Trim point start: " .. timestamp(pos))
		start_pos = pos
	else
		cut(start_pos, pos)
		start_pos = nil
	end

end

mp.add_forced_key_binding("t", "trim", mark)

