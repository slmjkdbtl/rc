# wengwengweng

function icns -d "remove git submodule" -a "in" -a "out"

	set -l icon_dir .tmp.iconset
	mkdir -p $icon_dir

	for s in 16 32 64 128 256 512
		convert $in -filter point -resize $s"x"$s "$icon_dir/icon_"$s"x"$s".png"
		convert $in -filter point -resize (expr $s \* 2)"x"(expr $s \* 2) "$icon_dir/icon_"$s"x"$s"@2x.png"
	end

	iconutil -c icns -o $out $icon_dir
	rm -rf $icon_dir

end

