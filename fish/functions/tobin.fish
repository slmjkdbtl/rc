# wengwengweng

function tobin -d "move executable to bin" -a "file"
	switch "$file"
		case ""
			c red; echo "no file provided"; c normal
			return 1
		case "*"
			if not test -e "$file"
				c red; echo "file not exist"; c normal
				return 1
			end
			chmod +x $file
			install -v $file $BIN
	end
end

