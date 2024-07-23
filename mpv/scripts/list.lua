-- library to display a selectable list

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
	padding = 32,
	font_size = 24,
	spacing = 2,
	scroll_off = 3,
}

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
	ov.data = ov.data .. "{\\alpha&H" .. string.format("%02x", 255 - a) .. "}"
end

function font_size(ov, s)
	ov.data = ov.data .. "{\\fs" .. pt(s) .. "}"
end

function draw_start(ov)
	append(ov, "{\\p1}")
end

function draw_end(ov)
	append(ov, "{\\p0}")
end

function color_hex(ov, hex)
	local r = string.sub(hex, 1, 2)
	local g = string.sub(hex, 3, 4)
	local b = string.sub(hex, 5, 6)
	ov.data = ov.data .. "{\\c&H" .. b .. g .. r .. "&}"
end

function color(ov, r, g, b)
	color_hex(ov, rgb2hex(r, g, b))
end

function pos(ov, x, y)
	ov.data = ov.data .. "{\\pos(" .. pt(x) .. "," .. pt(y) .. ")}"
end

-- TODO: this is a hack to get somewhat true coord
function pt(n)
	local s = mp.get_property_number("display-hidpi-scale")
	local oh = mp.get_property_number("osd-height") / s
	return math.floor(n * 720 / oh + 0.5)
end

function coord(ov, x, y)
	append(ov, " " .. pt(x) .. " " .. pt(y))
end

function move_to(ov, x, y)
	append(ov, " m")
	coord(ov, x, y)
end

function line_to(ov, x, y)
	append(ov, " l")
	coord(ov, x, y)
end

function rect(ov, x0, y0, x1, y1)
	move_to(ov, x0, y0)
	line_to(ov, x1, y0)
	line_to(ov, x1, y1)
	line_to(ov, x0, y1)
end

function rgb2hex(r, g, b)
	return string.format("%02x%02x%02x", r, g, b)
end

function list_init(name, list)

	local ov = mp.create_osd_overlay("ass-events")
	local opened = false
	local bs = function() end

	local l = {
		list = list,
		title = nil,
		selected = 1,
		bs = function() end,
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
		local max_lines = math.floor((oh - pd * 2) / (opts.font_size + sp)) - 2
		local y = 0
		y = y + pd
		clear(ov)
		draw_start(ov)
		alpha(ov, 150)
		pos(ov, 0, 0)
		color(ov, 0, 0, 0)
		rect(ov, 0, 0, ow, oh)
		nl(ov)
		draw_end(ov)
		if l.title then
			bold(ov)
			color_hex(ov, theme.yellow)
			pos(ov, pd, y)
			font_size(ov, fs)
			append(ov, l.title)
			nl(ov)
			y = y + fs + sp
		end
		local start = 1
		if l.selected > max_lines - opts.scroll_off then
			start = l.selected - (max_lines - opts.scroll_off)
		end
		for i = start, math.min(start + max_lines, #l.list) do
			local item = l.list[i]
			pos(ov, pd, y)
			font_size(ov, fs)
			if item.color and theme[item.color] then
				color_hex(ov, theme[item.color])
			end
			if i == l.selected then
				bold(ov)
				append(ov, "> ")
			else
				alpha(ov, 200)
				-- TODO: white space not working
				append(ov, "  ")
			end
			append(ov, item.name)
			nl(ov)
			y = y + fs + sp
		end
		ov:update()
	end

	function input_bind()
		mp.add_forced_key_binding("up", name .. "-up", up)
		mp.add_forced_key_binding("down", name .. "-down", down)
		mp.add_forced_key_binding("wheel_up", name .. "-wheel-up", up)
		mp.add_forced_key_binding("wheel_down", name .. "-wheel-down", down)
		mp.add_forced_key_binding("enter", name .. "-enter", enter)
		mp.add_forced_key_binding("bs", name .. "-bs", bs)
		mp.add_forced_key_binding("esc", name .. "-esc", l.close)
	end

	function input_unbind()
		mp.remove_key_binding(name .. "-up")
		mp.remove_key_binding(name .. "-down")
		mp.remove_key_binding(name .. "-wheel-up")
		mp.remove_key_binding(name .. "-wheel-down")
		mp.remove_key_binding(name .. "-enter")
		mp.remove_key_binding(name .. "-bs")
		mp.remove_key_binding(name .. "-esc")
	end

	local on_open = {}

	function l.open()
		opened = true
		for _, action in ipairs(on_open) do
			action()
		end
		l.draw()
		input_bind()
	end

	function l.close()
		opened = false
		clear(ov)
		ov:update()
		input_unbind()
	end

	function l.toggle()
		if opened then
			l.close()
		else
			l.open()
		end
	end

	function up()
		if l.selected > 1 then
			l.selected = l.selected - 1
			l.draw()
		end
	end

	function down()
		if l.selected < #l.list then
			l.selected = l.selected + 1
			l.draw()
		end
	end

	function bs()
		l.bs()
	end

	function enter()
		local item = l.list[l.selected]
		if item and item.on_enter then
			item.on_enter()
		end
	end

	function l.on_open(action)
		on_open[#on_open + 1] = action
	end

	mp.observe_property("osd-height", "number", function()
		if opened then
			l.draw()
		end
	end)

	return l

end

return list_init
