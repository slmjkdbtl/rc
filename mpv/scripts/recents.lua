-- select from a list of recent files

package.path = package.path .. ";" .. mp.find_config_file("scripts") .. "/?.lua"

local options = require("mp.options")
local list_init = require("list")
local u = require("utils")
local script_name = mp.get_script_name()

local opts = {
	log_path = "~/Library/Caches/mpv/history.log",
	log_max = 128,
}

options.read_options(opts)

local l = list_init({
	name = script_name,
})

local log_path = u.expand(opts.log_path)

l.on_open(function()
	local f = io.open(log_path, "r")
	local list = {}
	if f then
		for path in f:lines() do
			if u.file_exists(path) then
				list[#list + 1] = {
					text = u.tidy_path(path),
					on_enter = function()
						mp.commandv("loadfile", path)
					end,
				}
			end
		end
		f:close()
	end
	l.list = list
	l.title = "recent files"
	l.selected = 1
end)

function append_log(path)
	local paths = {}
	local f = io.open(log_path, "r")
	if f then
		for line in f:lines() do
			if line ~= path and u.file_exists(line) then
				paths[#paths + 1] = line
				if #paths >= opts.log_max - 1 then
					break
				end
			end
		end
		f:close()
	end
	table.insert(paths, 1, path)
	f = io.open(log_path, "w")
	f:write(table.concat(paths, "\n"))
	f:close()
end

-- TODO: only record when video is opened for X seconds
mp.add_hook("on_unload", 50, function()
	local path = mp.get_property("path")
	append_log(path)
end)

mp.add_forced_key_binding("alt+r", script_name .. "-toggle", l.toggle)
