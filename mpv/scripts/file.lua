local utils = require("mp.utils")

local padding = 32
local spacing = 2

local ov = mp.create_osd_overlay("ass-events")
local state = nil

function print(s)
	mp.msg.info(s)
	mp.osd_message(s)
end

function clear()
	ov.data = ""
end

function append(t)
	ov.data = ov.data .. t
end

function nl(t)
	ov.data = ov.data .. "\n"
end

function bold(t)
	ov.data = ov.data .. "{\\b1}"
end

function alpha(a)
	ov.data = ov.data .. "{\\alpha&H" .. a .. "}"
end

function font_size(s)
	ov.data = ov.data .. "{\\fs" .. s .. "}"
end

function rgb2hex(r, g, b)
	return string.format("%02x%02x%02x", r, g, b)
end

function color(hex)
	local r = string.sub(hex, 1, 2)
	local g = string.sub(hex, 3, 4)
	local b = string.sub(hex, 5, 6)
	ov.data = ov.data .. "{\\c&H" .. b .. g .. r .. "&}"
end

function pos(x, y)
	ov.data = ov.data .. "{\\pos(" .. x .. "," .. y .. ")}"
end

function table_join(t1, t2)
	local t = {}
	for i = 1, #t1 do
		t[i] = t1[i]
	end
	for i = 1, #t2 do
		t[#t1 + i] = t2[i]
	end
	return t
end

function draw()
	if not state then
		return
	end
	local y = 0
	clear()
	bold()
	y = y + padding
	pos(padding, y)
	font_size(24)
	color(rgb2hex(255, 255, 0))
	append(state.dir)
	y = y + 24 + spacing * 2
	nl()
	for i, item in ipairs(state.list) do
		font_size(20)
		pos(padding + 8, y)
		if item.type == "dir" then
			color("8abbff")
		end
		if i == state.selected then
			bold()
			append("> ")
		else
			-- TODO: white space not working
			append("  ")
		end
		append(item.name)
		if item.type == "dir" then
			append("/")
		end
		y = y + 20 + spacing
		nl()
	end
	ov:update()
end

function up()
	if not state then
		return
	end
	if state.selected > 1 then
		state.selected = state.selected - 1
	end
	draw()
end

function down()
	if not state then
		return
	end
	if state.selected < #state.list then
		state.selected = state.selected + 1
	end
	draw()
end

function enter()
	if not state then
		return
	end
	local item = state.list[state.selected]
	local path = utils.join_path(state.dir, item.name)
	if item.type == "dir" then
		-- TODO
	elseif item.type == "file" then
		mp.commandv("loadfile", path, "replace")
	end
end

function cd()
	-- TODO
end

function cd_up()
	-- TODO
end

function bind_keys()
	mp.add_forced_key_binding("up", "file-up", up)
	mp.add_forced_key_binding("down", "file-down", down)
	mp.add_forced_key_binding("wheel_up", "file-wheel-up", up)
	mp.add_forced_key_binding("wheel_down", "file-wheel-down", down)
	mp.add_forced_key_binding("enter", "file-enter", enter)
	mp.add_forced_key_binding("bs", "file-bs", cd_up)
	mp.add_forced_key_binding("esc", "file-esc", close)
end

function unbind_keys()
	mp.remove_key_binding("file-up")
	mp.remove_key_binding("file-down")
	mp.remove_key_binding("file-wheel-up")
	mp.remove_key_binding("file-wheel-down")
	mp.remove_key_binding("file-enter")
	mp.remove_key_binding("file-bs")
	mp.remove_key_binding("file-esc")
end

function open()
	local path = mp.get_property("path")
	local dir, filename = utils.split_path(path)
	local dirs = utils.readdir(dir, "dirs")
	local files = utils.readdir(dir, "files")
	table.sort(dirs)
	table.sort(files)
	local selected = nil
	local list = {}
	for i = 1, #dirs do
		list[#list + 1] = {
			name = dirs[i],
			type = "dir",
		}
	end
	for i = 1, #files do
		list[#list + 1] = {
			name = files[i],
			type = "file",
		}
		if files[i] == filename then
			selected = #list
		end
	end
	if not selected then
		error("failed to get selected file")
		return
	end
	state = {
		selected = selected,
		dir = dir,
		list = list,
	}
	draw()
	bind_keys()
end

function close()
	state = nil
	clear()
	ov:update()
	unbind_keys()
end

function toggle()
	if state then
		close()
	else
		open()
	end
end

mp.add_key_binding("tab", "toggle_filetree", toggle)
