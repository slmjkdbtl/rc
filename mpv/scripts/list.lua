-- library to display a selectable list

package.path = package.path .. ";" .. mp.find_config_file("scripts") .. "/?.lua"

local options = require("mp.options")
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
	margin = 16,
	padding = 8,
	font_size = 24,
	spacing = 0,
	border = 4,
	scroll_off = 5,
	bg_alpha = 150,
}

options.read_options(opts)

function prop(name)
	return "user-data/list/" .. name
end

function list_init(cfg)

	if not cfg.name then
		error("list requires name")
	end

	local gfx = gfx_init()
	local is_opened = false
	local is_searching = false
	local query = ""
	local key_bindings = {}
	local search_key_bindings = {}
	local custom_key_bindings = {}
	local on_open = {}

	local l = {
		list = cfg.list or {},
		title = nil,
		selected = 1,
	}

	function l.is_opened()
		return is_opened
	end

	function l.is_searching()
		return is_searching
	end

	function filtered_list()
		local list = {}
		for _, item in ipairs(l.list) do
			if is_searching and #query > 0 then
				if string.find(string.lower(item.text), string.lower(query), 1, true) then
					list[#list + 1] = item
				end
			else
				list[#list + 1] = item
			end
		end
		return list
	end

	function l.draw()
		if not is_opened then return end
		local list = filtered_list()
		local ow = gfx.width()
		local oh = gfx.height()
		local mg = opts.margin
		local pd = opts.padding
		local fs = opts.font_size
		local sp = opts.spacing
		local scroll_off = opts.scroll_off
		local max_lines = math.floor((oh - mg * 2) / (opts.font_size + sp)) - 1
		if is_searching then
			max_lines = max_lines - 3
			scroll_off = scroll_off - 3
		end
		local y = 0
		y = y + mg
		gfx.clear()
		gfx.draw_start()
		gfx.alpha(opts.bg_alpha)
		gfx.pos(0, 0)
		gfx.color(0, 0, 0)
		gfx.rect(0, 0, ow, oh)
		gfx.nl()
		gfx.draw_end()
		if l.title then
			gfx.bold()
			gfx.color_hex(theme.yellow)
			gfx.pos(mg, y)
			gfx.font_size(fs)
			gfx.border(opts.border)
			gfx.no_wrap()
			if cfg.interactive ~= false then
				gfx.alpha(0)
				gfx.append("> ")
				gfx.alpha(255)
			end
			gfx.append(l.title)
			gfx.nl()
			y = y + fs + sp
		end
		local start = 1
		if l.selected > max_lines - scroll_off then
			start = l.selected - (max_lines - scroll_off)
		end
		for i = start, math.min(start + max_lines, #list) do
			local item = list[i]
			gfx.pos(mg, y)
			gfx.border(opts.border)
			gfx.font_size(fs)
			gfx.no_wrap()
			if item.color and theme[item.color] then
				gfx.color_hex(theme[item.color])
			end
			if cfg.interactive ~= false then
				if i == l.selected then
					gfx.bold()
					gfx.append("> ")
				else
					gfx.alpha(0)
					gfx.bold()
					gfx.append("> ")
					gfx.unbold()
					gfx.alpha(200)
				end
			end
			gfx.append(item.text)
			gfx.nl()
			y = y + fs + sp
		end
		if is_searching then
			local y = oh - mg - (fs + pd * 2)
			gfx.pos(mg, y)
			gfx.color(50, 50, 50)
			gfx.draw_start()
			gfx.rect(0, 0, ow - mg * 2, fs + pd * 2)
			gfx.nl()
			gfx.draw_end()
			gfx.pos(mg + pd, y + pd)
			gfx.font_size(fs)
			if query == "" then
				gfx.alpha(50)
				gfx.italic()
				gfx.append("search...")
			else
				gfx.append(query)
			end
			gfx.nl()
		end
		gfx.update()
	end

	function key_name(k)
		return cfg.name .. "-list-" .. k
	end

	function search_key_name(k)
		return cfg.name .. "-list-search-" .. k
	end

	function open()
		is_opened = true
		l.selected = 1
		for _, action in ipairs(on_open) do
			action()
		end
		l.draw()
		for key, bind in pairs(key_bindings) do
			mp.add_forced_key_binding(key, key_name(key), bind.action, { repeatable = bind.repeatable == true })
		end
		for key, bind in pairs(custom_key_bindings) do
			mp.add_forced_key_binding(key, key_name(key), bind.action, { repeatable = bind.repeatable == true })
		end
	end

	function l.open()
		mp.set_property_native(prop("active"), cfg.name)
		open()
	end

	function close()
		is_opened = false
		is_searching = false
		l.selected = 1
		query = ""
		gfx.clear()
		gfx.update()
		for key, action in pairs(key_bindings) do
			mp.remove_key_binding(key_name(key))
		end
		for key, action in pairs(custom_key_bindings) do
			mp.remove_key_binding(key_name(key))
		end
	end

	function l.close()
		mp.set_property_native(prop("active"), nil)
		close()
	end

	function l.toggle()
		if is_opened then
			l.close()
		else
			l.open()
		end
	end

	function up()
		if not is_opened then return end
		if l.selected > 1 then
			l.selected = l.selected - 1
			l.draw()
		end
	end

	function down()
		if not is_opened then return end
		if l.selected < #l.list then
			l.selected = l.selected + 1
			l.draw()
		end
	end

	function enter()
		if not is_opened then return end
		local list = filtered_list()
		local item = list[l.selected]
		if item and item.on_enter then
			item.on_enter()
		end
	end

	function l.on_open(action)
		on_open[#on_open + 1] = action
	end

	function l.set_key_binding(k, action)
		local new_action = function()
			if key_bindings[k] then
				key_bindings[k]()
			end
			action()
		end
		custom_key_bindings[k] = {
			action = new_action,
		}
		if is_opened then
			mp.add_forced_key_binding(k, key_name(k), new_action)
		end
	end

	function search_open()
		is_searching = true
		query = ""
		l.draw()
		for key, bind in pairs(search_key_bindings) do
			mp.add_forced_key_binding(key, search_key_name(key), bind.action, { repeatable = bind.repeatable == true })
		end
	end

	-- TODO: restore previous selection
	function search_close()
		is_searching = false
		query = ""
		l.draw()
		for key, action in pairs(search_key_bindings) do
			mp.remove_key_binding(search_key_name(key))
		end
	end

	function input_char(c)
		if not is_searching then return end
		query = query .. c
		l.selected = 1
		l.draw()
	end

	function search_toggle()
		if is_searching then
			search_close()
		else
			search_open()
		end
	end

	key_bindings["esc"] = {
		action = function()
			if is_searching then
				search_close()
			else
				l.close()
			end
		end,
	}

	if cfg.interactive ~= false then

		key_bindings["up"] = { action = up, repeatable = true }
		key_bindings["down"] = { action = down, repeatable = true }
		key_bindings["k"] = { action = up, repeatable = true }
		key_bindings["j"] = { action = down, repeatable = true }
		key_bindings["wheel_up"] = { action = up, repeatable = true }
		key_bindings["wheel_down"] = { action = down, repeatable = true }
		key_bindings["enter"] = { action = enter }
		key_bindings["alt+f"] = { action = search_toggle }

		local keys = "qwertyuiopasdfghjklzxcvbnm1234567890,./'[]-=`"

		for i = 1, #keys do
			local c = keys:sub(i, i)
			search_key_bindings[c] = {
				action = function()
					input_char(c)
				end,
				repeatable = true,
			}
		end

		search_key_bindings["space"] = {
			action = function()
				input_char(" ")
			end,
			repeatable = true,
		}

		search_key_bindings["bs"] = {
			action = function()
				if #query > 0 then
					query = query:sub(1, #query - 1)
					l.selected = 1
					l.draw()
				end
			end,
			repeatable = true,
		}

	end

	mp.observe_property(prop("active"), "native", function(k, v)
		if is_opened and v ~= cfg.name then
			close()
		end
	end)

	mp.observe_property("osd-height", "number", function()
		if is_opened then
			l.draw()
		end
	end)

	return l

end

return list_init
