# wengwengweng

function fplug -d "fish plugin manager" -a "command"

	function load -d "load a plugin" -a "repo"

		set -g fplug_plugins $fplug_plugins $repo
		set -l name (string split "/" "$repo")[2]

		if test -d $fplug_path/$name

			for i in $fplug_path/$name/functions/*.fish
				source $i >/dev/null 2>&1
			end

			for i in $fplug_path/$name/conf.d/*.fish
				source $i >/dev/null 2>&1
			end

			for i in $fplug_path/$name/*.fish
				source $i >/dev/null 2>&1
			end

		end

	end

	function install -d "install plugins"

		if test (count $fplug_plugins) -gt 0

			echo "+ installing"

			for repo in $fplug_plugins

				set -l name (string split "/" "$repo")[2]
				set -l dir $fplug_path/$name

				if test -d $dir

					echo "  - updating $repo"
					pushd $dir
					git pull >/dev/null 2>&1
					popd

				else

					echo "  - installing $repo"
					git clone $repo $fplug_path/$name >/dev/null 2>&1

				end


			end

		else

			echo "no plugins"

		end

	end

	if test -z $fplug_path
		set -g fplug_path "$HOME/.config/fish/plugins"
	end

	switch "$command"
		case load
			load $argv[2]
		case install
			install $argv[2]
		case "*"
			echo "command not found"
	end

	functions -e load
	functions -e install

end

