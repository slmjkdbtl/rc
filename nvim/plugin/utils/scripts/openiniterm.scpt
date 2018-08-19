-- wengwengweng

on run argv

	set command to "clear; cd " & item 1 of argv

	tell application "System Events"
		set isRunning to (exists (processes where name is "iTerm")) or (exists (processes where name is "iTerm2"))
	end tell

	tell application "iTerm"

		activate

		set hasNoWindows to ((count of windows) is 0)

		if isRunning and hasNoWindows then
			create window with default profile
		end if

		select first window

		tell the first window

			if isRunning and hasNoWindows is false then
				create tab with default profile
			end if

			if class of command is string then
				tell current session to write text command
			end if

		end tell

	end tell

end run

