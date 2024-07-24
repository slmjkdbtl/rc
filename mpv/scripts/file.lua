-- file browser

package.path = package.path .. ";" .. mp.find_config_file("scripts") .. "/?.lua"

local utils = require("mp.utils")
local u = require("utils")
local list_init = require("list")

local l = list_init(mp.get_script_name(), {})

local ignore = {
	".git",
	".DS_Store",
}

local media_ext = {
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
			color = "blue",
			on_enter = function()
				cd(path)
			end,
		}
	end
	for i, name in ipairs(files) do
		local ext = name:match("[^.]+$")
		if u.table_has(media_ext, ext) and not u.table_has(ignore, name) then
			local path = utils.join_path(dir, name)
			list[#list + 1] = {
				name = name,
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
				if utils.join_path(to_dir, item.name) == dir .. "/" then
					l.selected = i
					l.draw()
					break
				end
			end
		end
	end)
	l.draw()
end

l.on_open(function()
	local path = mp.get_property("path")
	local dir, filename = utils.split_path(path)
	cd(string.sub(dir, 1, #dir - 1))
end)

mp.add_key_binding("tab", "file-toggle", l.toggle)
