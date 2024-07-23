-- show info and metadata

package.path = package.path .. ";" .. mp.find_config_file("scripts") .. "/?.lua"

local init_gfx = require("gfx")
local gfx = init_gfx()
local opened = false

function readable_size(bytes)
	if bytes >= math.pow(1024, 4) then
		return string.format("%.2ftb", bytes / 1024 / 1024 / 1024 / 1024)
	elseif bytes >= math.pow(1024, 3) then
		return string.format("%.2fgb", bytes / 1024 / 1024 / 1024)
	elseif (bytes >= math.pow(1024, 2)) then
		return string.format("%.2fmb", bytes / 1024 / 1024)
	elseif (bytes >= math.pow(1024, 1)) then
		return string.format("%.2fkb", bytes / 1024)
	else
		return bytes .. "b"
	end
end

function readable_time(secs)
	local hr = math.floor(secs / 60 / 60)
	local min = math.floor(secs / 60 - hr * 60)
	local sec = math.floor(secs) % 60
	return string.format("%02d:%02d:%02d", hr, min, sec)
end

function open()
	opened = true
	local meta = mp.get_property_native("metadata")
	local path = mp.get_property("path")
	local width = mp.get_property_number("width")
	local height = mp.get_property_number("height")
	local duration = mp.get_property("duration")
	local size = mp.get_property_number("file-size")
	local num_tracks = mp.get_property_number("track-list/count")
	local data = {}
	if meta then
		if meta["title"] then
			data[#data + 1] = { "Title", meta["title"] }
		end
		if meta["artist"] then
			data[#data + 1] = { "Artist", meta["artist"] }
		end
		if meta["date"] then
			data[#data + 1] = { "Date", meta["date"] }
		end
	end
	if path then
		data[#data + 1] = { "Path", path }
	end
	if width and height then
		data[#data + 1] = { "Resolution", width .. "x" .. height }
	end
	if duration then
		data[#data + 1] = { "Duration", readable_time(duration) }
	end
	if size then
		data[#data + 1] = { "Size", readable_size(size) }
	end
	for i = 1, num_tracks do
		local ty = mp.get_property("track-list/" .. i .. "/type")
		local codec = mp.get_property("track-list/" .. i .. "/codec")
		if ty and codec then
			data[#data + 1] = { "Track " .. i, ty .. "/" .. codec }
		end
	end
	gfx.clear()
	for _, d in ipairs(data) do
		local key = d[1]
		local val = d[2]
		gfx.font_size(24)
		gfx.border(4)
		gfx.append(key .. ": " .. val)
		gfx.nl()
	end
	gfx.update()
end

function close()
	opened = false
	gfx.clear()
	gfx.update()
end

function toggle()
	if opened then
		close()
	else
		open()
	end
end

-- TODO: doesn't work on full screen
mp.add_hook("on_before_start_file", 50, function()
	if opened then
		open()
	end
end)

mp.observe_property("osd-height", "number", function()
	if opened then
		open()
	end
end)

mp.add_key_binding("i", "toggle_info", toggle)
