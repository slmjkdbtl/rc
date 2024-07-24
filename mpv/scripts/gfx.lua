-- graphics helper
-- https://aegisub.org/docs/latest/ass_tags

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

	function g.nl()
		g.append("\n")
	end

	function g.bold()
		g.append("{\\b1}")
	end

	function g.unbold()
		g.append("{\\b0}")
	end

	function g.italic()
		g.append("{\\i1}")
	end

	function g.unitalic()
		g.append("{\\i0}")
	end

	function g.underline()
		g.append("{\\u1}")
	end

	function g.ununderline()
		g.append("{\\u0}")
	end

	function g.strikeout()
		g.append("{\\s1}")
	end

	function g.unstrikeout()
		g.append("{\\s0}")
	end

	function g.alpha(a)
		g.append("{\\alpha&H" .. string.format("%02x", 255 - a) .. "}")
	end

	function g.font_size(s)
		g.append("{\\fs" .. pt(s) .. "}")
	end

	function g.font(f)
		g.append("{\\fn" .. f .. "}")
	end

	function g.font_scale(s)
		g.append("{\\fscx" .. s .. "}")
		g.append("{\\fscy" .. s .. "}")
	end

	function g.letter_spacing(s)
		g.append("{\\fsp" .. pt(s) .. "}")
	end

	function g.text_rotate_x(d)
		g.append("{\\frx" .. d .. "}")
	end

	function g.text_rotate_y(d)
		g.append("{\\fry" .. d .. "}")
	end

	function g.text_rotate(d)
		g.append("{\\frz" .. d .. "}")
	end

	function g.text_shear_x(s)
		g.append("{\\fax" .. s .. "}")
	end

	function g.text_shear_y(s)
		g.append("{\\fay" .. s .. "}")
	end

	function g.border(s)
		g.append("{\\bord" .. pt(s) .. "}")
	end

	function g.shadow(d)
		g.append("{\\shad" .. pt(d) .. "}")
	end

	function g.blur(s)
		g.append("{\\be" .. s .. "}")
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

	function g.no_wrap()
		g.append("{\\q2}")
	end

	function g.reset()
		g.append("{\\r}")
	end

	function g.karaoke(d)
		g.append("{\\k" .. d .. "}")
	end

	function g.fade(a, b)
		g.append("{\\fad(" .. a .. "," .. b .. ")}")
	end

	function g.draw_start()
		g.append("{\\p1}")
	end

	function g.draw_end()
		g.append("{\\p0}")
	end

	function g.pos(x, y)
		g.append("{\\pos(" .. pt(x) .. "," .. pt(y) .. ")}")
	end

	function g.align(l)
		g.append("{\\an(" .. l .. ")}")
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

	function g.remove()
		ov:remove()
	end

	function g.width()
		local s = mp.get_property_number("display-hidpi-scale")
		local w, h = mp.get_osd_size()
		return w / s
	end

	function g.height()
		local s = mp.get_property_number("display-hidpi-scale")
		local w, h = mp.get_osd_size()
		return h / s
	end

	return g

end

return gfx_init
