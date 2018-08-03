# wengwengweng

function plug -d "fish plugin manager" -a "repo"

	set -u name (string split "/" $repo)[2]

	if test -n $fish_plug_path
		set -u path $fish_plug_path
	else
		set -u path "~/.config/fish/plugins"
	end

	mkdir -p $path

	for i in $path/$name/functions/*.fish
		source $i 2> /dev/null
	end

	for i in $path/$name/conf.d/*.fish
		source $i 2> /dev/null
	end

end

