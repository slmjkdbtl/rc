-- library to display a selectable list

package.path = package.path .. ";" .. mp.find_config_file("scripts") .. "/?.lua"

local init_gfx = require("gfx")

local theme = {
	bg      = "000000",
	black   = "666666",
	red     = "ec7580",
	green   = "9ae0a0",
	yellow  = "ffca72",
	blue    = "8abbff",
	magenta = "f7aad7",
	cyan    = "7ce9df",
	white   = "dadada",
}

local opts = {
	padding = 16,
	font_size = 24,
	spacing = 2,
	scroll_off = 3,
}

function list_init(name, list)

	local gfx = gfx_init()
	local opened = false
	local key_bindings = {}
	local on_open = {}

	local l = {
		list = list,
		title = nil,
		selected = 1,
	}

	function l.is_opened()
		return opened
	end

	function l.draw()
		if not opened then return end
		local s = mp.get_property_number("display-hidpi-scale")
		local ow = mp.get_property_number("osd-width") / s
		local oh = mp.get_property_number("osd-height") / s
		local pd = opts.padding
		local fs = opts.font_size
		local sp = opts.spacing
		local max_lines = math.floor((oh - pd * 2) / (opts.font_size + sp)) - 1
		local y = 0
		y = y + pd
		gfx.clear()
		gfx.draw_start()
		gfx.alpha(150)
		gfx.pos(0, 0)
		gfx.color(0, 0, 0)
		gfx.rect(0, 0, ow, oh)
		gfx.nl()
		gfx.draw_end()
		if l.title then
			gfx.bold()
			gfx.color_hex(theme.yellow)
			gfx.pos(pd, y)
			gfx.font_size(fs)
			gfx.append(l.title)
			gfx.nl()
			y = y + fs + sp
		end
		local start = 1
		if l.selected > max_lines - opts.scroll_off then
			start = l.selected - (max_lines - opts.scroll_off)
		end
		for i = start, math.min(start + max_lines, #l.list) do
			local item = l.list[i]
			gfx.pos(pd, y)
			gfx.font_size(fs)
			if item.color and theme[item.color] then
				gfx.color_hex(theme[item.color])
			end
			if i == l.selected then
				gfx.bold()
				gfx.append("> ")
			else
				gfx.alpha(200)
				-- TODO: white space not working
				gfx.append("  ")
			end
			gfx.append(item.name)
			gfx.nl()
			y = y + fs + sp
		end
		gfx.update()
	end

	function l.open()
		opened = true
		for _, action in ipairs(on_open) do
			action()
		end
		l.draw()
		for key, action in pairs(key_bindings) do
			mp.add_forced_key_binding(key, name .. "-" .. key, action)
		end
	end

	function l.close()
		opened = false
		gfx.clear()
		gfx.update()
		for key, action in pairs(key_bindings) do
			mp.remove_key_binding(name .. "-" .. key)
		end
	end

	function l.toggle()
		if opened then
			l.close()
		else
			l.open()
		end
	end

	function l.up()
		if not opened then return end
		if l.selected > 1 then
			l.selected = l.selected - 1
			l.draw()
		end
	end

	function l.down()
		if not opened then return end
		if l.selected < #l.list then
			l.selected = l.selected + 1
			l.draw()
		end
	end

	function l.enter()
		if not opened then return end
		local item = l.list[l.selected]
		if item and item.on_enter then
			item.on_enter()
		end
	end

	function l.on_open(action)
		on_open[#on_open + 1] = action
	end

	function l.set_key_binding(k, action)
		key_bindings[k] = action
		if opened then
			mp.add_forced_key_binding(k, name .. "-" .. k, action)
		end
	end

	l.set_key_binding("up", l.up)
	l.set_key_binding("down", l.down)
	l.set_key_binding("wheel_up", l.up)
	l.set_key_binding("wheel_down", l.down)
	l.set_key_binding("enter", l.enter)
	l.set_key_binding("esc", l.close)

	mp.observe_property("osd-height", "number", function()
		if opened then
			l.draw()
		end
	end)

	return l

end

return list_init
