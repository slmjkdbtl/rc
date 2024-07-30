-- show info and metadata

package.path = package.path .. ";" .. mp.find_config_file("scripts") .. "/?.lua"

local init_gfx = require("gfx")
local u = require("utils")
local gfx = init_gfx()
local opened = false

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
		data[#data + 1] = { "Duration", u.readable_time(duration) }
	end
	if size then
		data[#data + 1] = { "Size", u.readable_size(size) }
	end
	for i = 0, num_tracks - 1 do
		local ty = mp.get_property("track-list/" .. i .. "/type")
		local codec = mp.get_property("track-list/" .. i .. "/codec")
		local default = mp.get_property_native("track-list/" .. i .. "/default")
		if ty and codec then
			local text = ty .. "/" .. codec
			if default then
				text = text .. " (default)"
			end
			data[#data + 1] = { "Track " .. i, text }
		end
	end
	gfx.clear()
	for _, d in ipairs(data) do
		local key = d[1]
		local val = d[2]
		gfx.font_size(24)
		gfx.border(4)
		gfx.color(180, 180, 180)
		gfx.append(key)
		gfx.append(" ")
		gfx.color(255, 255, 255)
		gfx.append(val)
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

mp.register_event("file-loaded", function()
	if opened then
		open()
	end
end)

mp.observe_property("osd-height", "number", function()
	if opened then
		open()
	end
end)

mp.add_forced_key_binding("i", "toggle_info", toggle)
