local log_path = mp.command_native({ "expand-path", "~/Library/Caches/mpv/history.log" })

function read_log(p)
	local f = io.open(log_path, "r")
	if not f then return end
	local list = {}
	for line in f:lines() do
		list[#list + 1] = line
	end
	f:close()
	return list
end
