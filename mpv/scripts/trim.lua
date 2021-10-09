local cmd_template = [[ ffmpeg -i "$in" -ss $start -to $end -c copy "$out" ]]
local start_pos = nil

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
	local path = mp.get_property("path")
	local t1 = timestamp(p1)
	local t2 = timestamp(p2)
	local out_path = path:gsub(escape(fname), string.format("%s (%s-%s).mp4", basename, t1, t2))

	local cmd = cmd_template:gsub("$in", path)
	local cmd = cmd:gsub("$out", out_path)
	local cmd = cmd:gsub("$start", t1)
	local cmd = cmd:gsub("$end", t2)

	mp.osd_message("Trimming...")

	if os.execute(cmd) then
		mp.osd_message("Trimmed: " .. out_path)
	else
		mp.osd_message("Error Trimming Video")
	end

end

function mark()

	local pos = mp.get_property_number("time-pos")

	if not start_pos then
		mp.osd_message("Trim point start: " .. timestamp(pos))
		start_pos = pos
	else
		cut(start_pos, pos)
		start_pos = nil
	end

end

mp.add_forced_key_binding("t", "trim", mark)
