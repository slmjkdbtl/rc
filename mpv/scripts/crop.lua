-- crop video

package.path = package.path .. ";" .. mp.find_config_file("scripts") .. "/?.lua"

local gfx_init = require("gfx")
local ffmpeg_path = "/opt/homebrew/bin/ffmpeg"
local gfx = gfx_init()

local key_bindings = {}
local state = nil

function screen_to_video_norm(point, dim)
	return {
		x = (point.x - dim.ml) / (dim.w - dim.ml - dim.mr),
		y = (point.y - dim.mt) / (dim.h - dim.mt - dim.mb)
	}
end

function draw()
	gfx.clear()
end

key_bindings["MOUSE_BTN0"] = {
	action = function()
		if not state then return
		print("a")
	end
}

key_bindings["MOUSE_MOVE"] = {
	action = function()
		if not state then return
		local x, y = mp.get_mouse_pos()
		local dim = mp.get_property_native("osd-dimensions")
		local vop = mp.get_property_native("video-out-params")
		local c = screen_to_video_norm({ x = x, y = y }, dim)
		draw()
		-- print(c.x * vop.w .. "x" .. c.y * vop.h)
	end
}

function start()
	bind()
end

function bind()
	for key, bind in pairs(key_bindings) do
		mp.add_forced_key_binding(key, "crop-" .. key, bind.action, {
			repeatable = bind.repeatable == true,
			complex = bind.complex == true,
		})
	end
end

function unbind()
	for key, action in pairs(key_bindings) do
		mp.remove_key_binding("crop-" .. key)
	end
end

bind()

mp.add_forced_key_binding("alt+c", "crop-start", start)
