-- trim video
-- press t to set start point, press t again at end point to trim
-- esc to cancel

-- TODO: add marker to seek bar indicating start pos

local ffmpeg_path = "/opt/homebrew/bin/ffmpeg"
local start_pos = nil
local trimming = false
local ov = mp.create_osd_overlay("ass-events")

function print(s)
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

	ov.data = "{\\an1}trimming..."
	ov:update()

	mp.command_native_async({
		name = "subprocess",
		args = {
			ffmpeg_path,
			"-i", src_path,
			"-ss", t1,
			"-to", t2,
			"-avoid_negative_ts", "make_zero",
			"-c", "copy",
			"-y",
			out_path
		},
		playback_only = false,
	}, function(success, res, err)
		-- TODO: not getting error
		if success then
			print("trimmed: " .. out_path)
		else
			print("trim error: " .. err)
		end
		trimming = false
		ov.data = ""
		ov:update()
	end)

end

function mark()

	if trimming then
		return
	end

	local pos = mp.get_property_number("time-pos")

	if not start_pos then
		start_pos = pos
		ov.data = "{\\an1}trim start: " .. timestamp(pos)
		ov:update()
	else
		cut(start_pos, pos)
		start_pos = nil
	end

end

function cancel()
	if trimming then
		return
	end
	start_pos = nil
	ov.data = ""
	ov:update()
end

mp.add_key_binding("alt+t", "trim", mark)
mp.add_key_binding("esc", "cancel", cancel)
