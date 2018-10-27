# wengwengweng

function ardu -d "run arduino" -a "board" -a "port" -a "path"

	arduino-cli compile --fqbn "$board" "$path"
	arduino-cli upload -p "$port" --fqbn "$board" "$path"

end
