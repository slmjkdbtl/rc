-- select from a list of recent files

package.path = package.path .. ';' .. mp.find_config_file("scripts") .. '/?.lua'

local utils = require("mp.utils")
local list_init = require("list")

local opts = {
	log_path = mp.command_native({ "expand-path", "~/Library/Caches/mpv/history.log" }),
	log_max = 100,
}

local l = list_init("file", {})

function tidy_path(p)
	local home = os.getenv("HOME")
	if (home) then
		p = p:gsub("^" .. home, "~")
	end
	return p
end

function open()
	local f = io.open(opts.log_path, "r")
	local list = {}
	if f then
		for line in f:lines() do
			list[#list + 1] = {
				name = tidy_path(line),
				on_enter = function()
					mp.commandv("loadfile", line, "replace")
				end,
			}
		end
		f:close()
	end
	l.list = list
	l.title = "recent files"
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

function append_log(path)
	local paths = {}
	local f = io.open(opts.log_path, "r")
	if f then
		for line in f:lines() do
			if line ~= path then
				paths[#paths + 1] = line
				if #paths >= opts.log_max - 1 then
					break
				end
			end
		end
		f:close()
	end
	table.insert(paths, 1, path)
	f = io.open(opts.log_path, "w")
	f:write(table.concat(paths, "\n"))
	f:close()
end

mp.add_hook("on_unload", 50, function()
	local path = mp.get_property("path")
	append_log(path)
end)

mp.add_key_binding("alt+r", "toggle_recents", toggle)
