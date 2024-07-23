-- file browser

package.path = package.path .. ";" .. mp.find_config_file("scripts") .. "/?.lua"

local utils = require("mp.utils")
local list_init = require("list")

local l = list_init("file", {})

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

function has(table, element)
	for _, value in pairs(table) do
		if value == element then
		  return true
		end
	end
	return false
end

function tidy_path(p)
	local home = os.getenv("HOME")
	if (home) then
		p = p:gsub("^" .. home, "~")
	end
	return p
end

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
		if has(media_ext, ext) and not has(ignore, name) then
			local path = utils.join_path(dir, name)
			list[#list + 1] = {
				name = name,
				on_enter = function()
					mp.commandv("loadfile", path, "replace")
				end,
			}
			if path == cur_path then
				selected = #list
			end
		end
	end
	l.list = list
	l.selected = selected
	l.title = tidy_path(dir)
	l.set_key_binding("bs", function()
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

mp.add_key_binding("tab", "toggle_filetree", l.toggle)
