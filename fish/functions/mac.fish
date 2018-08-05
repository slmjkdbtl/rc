# wengwengweng

function mac -d "macos utilities" -a "command"

	switch "$command"

		case show

			defaults write com.apple.finder AppleShowAllFiles TRUE
			killall Finder

		case hide

			defaults write com.apple.finder AppleShowAllFiles FALSE
			killall Finder

		case "*"

			echo "command not found"

	end

end
