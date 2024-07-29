-- file browser

package.path = package.path .. ";" .. mp.find_config_file("scripts") .. "/?.lua"

local utils = require("mp.utils")
local u = require("utils")
local list_init = require("list")
local script_name = mp.get_script_name()

local l = list_init({
	name = script_name,
})

local ignore = {
	".git",
	".DS_Store",
}

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
			text = name .. "/",
			color = "blue",
			on_enter = function()
				cd(path)
			end,
		}
	end
	for i, name in ipairs(files) do
		if u.is_media_file(name) and not u.table_has(ignore, name) then
			local path = utils.join_path(dir, name)
			list[#list + 1] = {
				text = name,
				on_enter = function()
					mp.commandv("loadfile", path)
				end,
			}
			if path == cur_path then
				selected = #list
			end
		end
	end
	l.list = list
	l.selected = selected
	l.title = u.tidy_path(dir)
	l.set_key_binding("bs", function()
		if l.is_searching() then return end
		local i = string.find(dir, "/[^/]*$")
		local to_dir = string.sub(dir, 1, i - 1)
		if to_dir ~= "" then
			cd(to_dir)
			for i, item in ipairs(l.list) do
				if utils.join_path(to_dir, item.text) == dir .. "/" then
					l.selected = i
					l.draw()
					break
				end
			end
		end
	end)
	l.draw()
end

function jump(n)
	local path = mp.get_property("path")
	local dir, filename = utils.split_path(path)
	local files = utils.readdir(dir, "files")
	table.sort(files)
	files = u.table_filter(files, u.is_media_file)
	local i = u.table_find(files, filename)
	if i and files[i + n] then
		local file = files[i + n]
		local path = utils.join_path(dir, file)
		mp.commandv("loadfile", path)
		mp.osd_message(file)
	end
end

function prev()
	jump(-1)
end

function nxt()
	jump(1)
end

function init()
	local path = mp.get_property("path")
	if path then
		local dir, filename = utils.split_path(path)
		cd(string.sub(dir, 1, #dir - 1))
	else
		cd(u.expand("~/"))
	end
end

l.on_open(init)

mp.register_event("file-loaded", function()
	if l.is_opened() then
		init()
	end
end)

mp.add_forced_key_binding("<", script_name .. "-prev", prev)
mp.add_forced_key_binding(">", script_name .. "-next", nxt)
mp.add_forced_key_binding("tab", script_name .. "-toggle", l.toggle)
