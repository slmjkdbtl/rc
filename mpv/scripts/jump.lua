-- jump between files

package.path = package.path .. ";" .. mp.find_config_file("scripts") .. "/?.lua"

local utils = require("mp.utils")
local u = require("utils")

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

-- TODO: use shift
mp.add_forced_key_binding("alt+,", "jump-prev", prev)
mp.add_forced_key_binding("alt+.", "jump-next", nxt)
