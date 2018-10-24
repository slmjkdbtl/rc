# wengwengweng

function space55 -a "thing"

	pushd $PWD

	set -l projects \
		wHEREStIGA \
		PFISH \
		DIRTY-FINGER \
		Big-Birds-Question-About-Life \
		Shoot-Ducks \
		SUPER-TURKEY-BOY \
		Drunken-Tavern

	function show_status

		if test $status -eq 0
			c green; echo "    * success"; c normal
		else
			c red; echo "    * fail"; c normal
		end

	end

	for i in $projects

		echo "+ $i"
		cd ~/Things/$i/core
		git pull 1>/dev/null
		show_status

	end

	popd

end

