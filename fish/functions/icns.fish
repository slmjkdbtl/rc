
function icns -d "remove git submodule" -a "file"

	set -l icon_dir .tmp.iconset
	mkdir -p $icon_dir

	for s in 16 32 64 128 256 512 1024
		convert $file -filter point -resize $s"x"$s "$icon_dir/icon_"$s"x"$s".png"
	end

	iconutil -c icns -o icon.icns $icon_dir
	rm -rf $icon_dir

end

