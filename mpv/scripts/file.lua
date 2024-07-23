-- file browser

local utils = require("mp.utils")

local ov = mp.create_osd_overlay("ass-events")
local ll = nil

function print(s)
	mp.msg.info(s)
	mp.osd_message(s)
end

function clear(ov)
	ov.data = ""
end

function append(ov, t)
	ov.data = ov.data .. t
end

function nl(ov, t)
	ov.data = ov.data .. "\n"
end

function bold(ov, t)
	ov.data = ov.data .. "{\\b1}"
end

function alpha(ov, a)
	ov.data = ov.data .. "{\\alpha&H" .. a .. "}"
end

function font_size(ov, s)
	ov.data = ov.data .. "{\\fs" .. s .. "}"
end

function color(ov, hex)
	local r = string.sub(hex, 1, 2)
	local g = string.sub(hex, 3, 4)
	local b = string.sub(hex, 5, 6)
	ov.data = ov.data .. "{\\c&H" .. b .. g .. r .. "&}"
end

function pos(ov, x, y)
	ov.data = ov.data .. "{\\pos(" .. x .. "," .. y .. ")}"
end

function rgb2hex(r, g, b)
	return string.format("%02x%02x%02x", r, g, b)
end

function list_init(name, ov, list)
	return {
		opened = false,
		name = name,
		ov = ov,
		list = list,
		title = nil,
		selected = 1,
		padding = 20,
		font_size = 24,
		spacing = 2,
	}
end

function list_draw(l)
	local s = mp.get_property_number("display-hidpi-scale")
	local oh = mp.get_property_number("osd-height") / s
	local vh = mp.get_property_number("height")
	local ov = l.ov
	local pd = l.padding
	-- TODO
	local fs = l.font_size * 720 / oh
	local sp = l.spacing
	local max_lines = math.floor((oh - pd * 2) / (l.font_size + sp)) - 1
	local lines = math.min(max_lines, #l.list)
	local y = 0
	y = y + pd
	clear(ov)
	if l.title then
		bold(ov)
		color(ov, rgb2hex(255, 255, 0))
		pos(ov, pd, y)
		font_size(ov, fs)
		append(ov, l.title)
		nl(ov)
		y = y + fs + sp
	end
	local start = 1
	if l.selected > lines - 3 then
		start = l.selected - (lines - 3)
	end
	for i = start, math.min(start + lines, #l.list) do
		local item = l.list[i]
		pos(ov, pd, y)
		font_size(ov, fs)
		if i == l.selected then
			bold(ov)
			append(ov, "> ")
		else
			-- TODO: white space not working
			append(ov, "  ")
		end
		append(ov, item.name)
		nl(ov)
		y = y + fs + sp
	end
	ov:update()
end

function list_input_bind(l)
	-- mp.observe_property("osd-height", "number", function() list_draw(l) end)
	mp.add_forced_key_binding("up", l.name .. "-up", function() list_up(l) end)
	mp.add_forced_key_binding("down", l.name .. "-down", function() list_down(l) end)
	mp.add_forced_key_binding("wheel_up", l.name .. "-wheel-up", function() list_up(l) end)
	mp.add_forced_key_binding("wheel_down", l.name .. "-wheel-down", function() list_down(l) end)
	mp.add_forced_key_binding("enter", l.name .. "-enter", function() list_enter(l) end)
	mp.add_forced_key_binding("bs", l.name .. "-bs", function() list_bs(l) end)
	mp.add_forced_key_binding("esc", l.name .. "-esc", function() list_close(l) end)
end

function list_input_unbind(l)
	mp.remove_key_binding(l.name .. "-up")
	mp.remove_key_binding(l.name .. "-down")
	mp.remove_key_binding(l.name .. "-wheel-up")
	mp.remove_key_binding(l.name .. "-wheel-down")
	mp.remove_key_binding(l.name .. "-enter")
	mp.remove_key_binding(l.name .. "-bs")
	mp.remove_key_binding(l.name .. "-esc")
end

function list_close(l)
	clear(l.ov)
	l.ov:update()
	list_input_unbind(l)
end

function list_up(l)
	if l.selected == 1 then return end
	for i = l.selected - 1, 1, -1 do
		if l.list[i].on_enter then
			l.selected = i
			list_draw(l)
			return
		end
	end
end

function list_down(l)
	if l.selected == #l.list then return end
	for i = l.selected + 1, #l.list do
		if l.list[i].on_enter then
			l.selected = i
			list_draw(l)
			return
		end
	end
end

function list_bs(l)
	-- TODO
end

function list_enter(l)
	local item = l.list[l.selected]
	if item and item.on_enter then
		item.on_enter()
	end
end

local allowed_ext = {
	"mp4",
	"mpeg",
	"mkv",
	"webm",
	"avi",
	"mov",
	"mp3",
	"wav",
	"aac",
	"ogg",
	"jpg",
	"jpeg",
	"png",
	"webp",
}

-- TODO: improve default selected
function cd(dir)
	local cur_path = mp.get_property("path")
	local dirs = utils.readdir(dir, "dirs")
	local files = utils.readdir(dir, "files")
	local selected = 1
	table.sort(dirs)
	table.sort(files)
	local list = {}
	for i, name in ipairs(dirs) do
		local path = utils.join_path(dir, name)
		list[#list + 1] = {
			name = name .. "/",
			on_enter = function()
				cd(path)
			end,
		}
	end
	for i, name in ipairs(files) do
		local path = utils.join_path(dir, name)
		list[#list + 1] = {
			name = name,
			on_enter = function()
				local ext = name:match("[^.]+$")
				local allowed = false
				for i, aext in ipairs(allowed_ext) do
					if ext == aext then
						allowed = true
						break
					end
				end
				if allowed then
					mp.commandv("loadfile", path, "replace")
				else
					-- TODO
				end
			end,
		}
		if path == cur_path then
			selected = #list
		end
	end
	ll.list = list
	ll.selected = selected
	ll.title = dir
	list_draw(ll)
end

function open()
	local path = mp.get_property("path")
	local dir, filename = utils.split_path(path)
	ll = list_init("file", ov, {})
	cd(string.sub(dir, 1, #dir - 1))
	list_input_bind(ll)
	-- ll.bs = function()
		-- local i = string.find(state.dir, "/[^/]*$")
		-- local dir = string.sub(state.dir, 1, i - 1)
		-- cd(dir)
	-- end
end

function close()
	list_close(ll)
	ll = nil
end

function toggle()
	if ll then
		close()
	else
		open()
	end
end

mp.add_key_binding("tab", "toggle_filetree", toggle)
