# wengwengweng

function img -a "file"

	amulet ~/.tools/img.lua (realpath --relative-to="$HOME/.tools" $file) $file

end

