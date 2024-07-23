-- file browser

package.path = package.path .. ';' .. mp.find_config_file("scripts") .. '/?.lua'

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
		if not has(ignore, name) then
			local path = utils.join_path(dir, name)
			list[#list + 1] = {
				name = name,
				on_enter = function()
					local ext = name:match("[^.]+$")
					if has(media_ext, ext) then
						mp.commandv("loadfile", path, "replace")
					else
						-- TODO
					end
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
	l.bs = function()
		-- TODO: select last dir
		local i = string.find(dir, "/[^/]*$")
		local to_dir = string.sub(dir, 1, i - 1)
		cd(to_dir)
	end
	l.draw()
end

function open()
	local path = mp.get_property("path")
	local dir, filename = utils.split_path(path)
	cd(string.sub(dir, 1, #dir - 1))
	l.open()
end

function close()
	l.close()
end

function toggle()
	if l.is_opened() then
		close()
	else
		open()
	end
end

mp.add_key_binding("tab", "toggle_filetree", toggle)
