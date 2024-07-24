local u = {}

function u.exec(cmds, opts)
	return mp.command_native_async({
		name = "subprocess",
		args = cmds,
		playback_only = false,
	}, action)
end

function u.expand(p)
	return mp.command_native({ "expand-path", p })
end

function u.tidy_path(p)
	local home = os.getenv("HOME")
	if (home) then
		p = p:gsub("^" .. home, "~")
	end
	return p
end

function u.file_exists(path)
	local f = io.open(path,"r")
	if f == nil then
		return false
	else
		f:close()
		return true
	end
end

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

function u.is_media_file(p)
	local ext = p:match("[^.]+$")
	return u.table_has(media_ext, ext)
end

function u.table_merge(t1, t2)
	local t = {}
	for k, v in pairs(t1) do
		t[k] = v
	end
	for k, v in pairs(t2) do
		t[k] = v
	end
	return t
end

function u.table_join(t1, t2)
	local t = {}
	for i = 1, #t1 do
		t[#t + 1] = t1[i]
	end
	for i = 1, #t2 do
		t[#t + 1] = t2[i]
	end
	return t
end

function u.table_has(t, element)
	for _, val in pairs(t) do
		if val == element then
		  return true
		end
	end
	return false
end

function u.table_map(t, fn)
	local t2 = {}
	for k, val in pairs(t) do
		t2[k] = fn(val)
	end
	return t2
end

function u.table_filter(t, fn)
	local t2 = {}
	for i, val in ipairs(t) do
		if fn(val) then
			t2[#t2 + 1] = val
		end
	end
	return t2
end

function u.table_find(t, item)
	for k, val in pairs(t) do
		if val == item then
			return k
		end
	end
	return nil
end

return u
