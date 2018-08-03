-- wengwengweng

on run argv

	set customcommand to ""

	if (count of argv) > 0
		set customcommand to item 1 of argv
	end if

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

		end tell

	end tell

	tell application "Finder"

		set pathList to (quoted form of POSIX path of (folder of the front window as alias))
		set command to "clear; cd " & pathList

	end tell

	tell application "iTerm"

		select first window

		tell the first window

			if class of command is string then
				tell current session to write text command
			end if

			tell current session to write text customcommand

		end tell

	end tell

end run

