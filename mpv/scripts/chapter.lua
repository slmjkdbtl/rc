-- select from chapters

package.path = package.path .. ";" .. mp.find_config_file("scripts") .. "/?.lua"

local script_name = mp.get_script_name()
local list_init = require("list")
local u = require("utils")

local l = list_init({
	name = script_name,
})

l.on_open(function()
	local cur_chapter = mp.get_property_number("chapter")
	local num_chapters = mp.get_property_number("chapters")
	local list = {}
	for i = 1, num_chapters - 1 do
		local title = mp.get_property("chapter-list/" .. i .."/title")
		local time = mp.get_property_number("chapter-list/" .. i .."/time")
		list[#list + 1] = {
			text = (title or "") .. " (" .. u.readable_time(time) .. ")",
			on_enter = function()
				mp.commandv("seek", time, "absolute")
			end,
		}
	end
	l.title = "chapters"
	l.list = list
	l.selected = cur_chapter
end)

function cycle(n)
	local cur_chapter = mp.get_property_number("chapter")
	local num_chapters = mp.get_property_number("chapters")
	local dest = cur_chapter + n
	if dest >= 1 and dest < num_chapters then
		local time = mp.get_property_number("chapter-list/" .. dest .."/time")
		mp.commandv("seek", time, "absolute")
	end
end

function prev()
	cycle(-1)
end

function next()
	cycle(1)
end

mp.add_forced_key_binding("alt+,", script_name .. "-prev", prev)
mp.add_forced_key_binding("alt+.", script_name .. "-next", next)
mp.add_forced_key_binding("alt+c", script_name .. "-toggle", l.toggle)
