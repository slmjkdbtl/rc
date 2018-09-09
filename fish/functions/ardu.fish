# wengwengweng

function ardu -d "run arduino" -a "board" -a "port" -a "path"

	arduino-cli compile --fqbn arduino:avr:leonardo "$path"
	arduino-cli upload -p "$port" --fqbn arduino:avr:leonardo "$path"

end
