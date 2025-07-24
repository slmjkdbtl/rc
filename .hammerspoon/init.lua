-- convert simplified to traditional chinese
hs.hotkey.bind({"cmd", "shift"}, "t", function()
	local oldClipboard = hs.pasteboard.getContents()
	hs.eventtap.keyStroke({"cmd"}, "c")
	-- hs.timer.usleep(100000)
	local text = hs.pasteboard.getContents()
	if not text or text == "" then
		return
	end
	local output, status, _, rc = hs.execute("printf '" .. text .. "' | /opt/homebrew/bin/opencc -c s2t.json", true)
	if status and rc == 0 and output and output ~= "" then
		hs.pasteboard.setContents(output)
		hs.eventtap.keyStroke({"cmd"}, "v")
		-- hs.timer.usleep(100000)
	else
		hs.alert("failed to convert to traditional")
	end
	hs.pasteboard.setContents(oldClipboard)
end)
