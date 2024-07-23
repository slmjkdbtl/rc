-- graphics helper

-- TODO: this is a hack to get somewhat true coord
function pt(n)
	local s = mp.get_property_number("display-hidpi-scale")
	local oh = mp.get_property_number("osd-height") / s
	return math.floor(n * 720 / oh)
end

function rgb2hex(r, g, b)
	return string.format("%02x%02x%02x", r, g, b)
end

function gfx_init()

	local g = {}
	local ov = mp.create_osd_overlay("ass-events")

	function g.clear()
		ov.data = ""
	end

	function g.append(t)
		ov.data = ov.data .. t
	end

	function g.nl(t)
		g.append("\n")
	end

	function g.bold(t)
		g.append("{\\b1}")
	end

	function g.unbold(t)
		g.append("{\\b0}")
	end

	function g.italic(t)
		g.append("{\\i1}")
	end

	function g.unitalic(t)
		g.append("{\\i0}")
	end

	function g.alpha(a)
		g.append("{\\alpha&H" .. string.format("%02x", 255 - a) .. "}")
	end

	function g.font_size(s)
		g.append("{\\fs" .. pt(s) .. "}")
	end

	function g.draw_start()
		g.append("{\\p1}")
	end

	function g.draw_end()
		g.append("{\\p0}")
	end

	function g.color_hex(hex)
		local r = string.sub(hex, 1, 2)
		local gg = string.sub(hex, 3, 4)
		local b = string.sub(hex, 5, 6)
		g.append("{\\c&H" .. b .. gg .. r .. "&}")
	end

	function g.color(r, gg, b)
		g.color_hex(rgb2hex(r, gg, b))
	end

	function g.pos(x, y)
		g.append("{\\pos(" .. pt(x) .. "," .. pt(y) .. ")}")
	end

	function g.coord(x, y)
		g.append(" " .. pt(x) .. " " .. pt(y))
	end

	function g.move_to(x, y)
		g.append(" m")
		g.coord(x, y)
	end

	function g.line_to(x, y)
		g.append(" l")
		g.coord(x, y)
	end

	function g.rect(x0, y0, x1, y1)
		g.move_to(x0, y0)
		g.line_to(x1, y0)
		g.line_to(x1, y1)
		g.line_to(x0, y1)
	end

	function g.update()
		ov:update()
	end

	return g

end

return gfx_init
