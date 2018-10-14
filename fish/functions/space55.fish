# wengwengweng

function space55 -a "thing"

	set -l projects \
		wHEREStIGA \
		PFISH \
		DIRTY-FINGER \
		Big-Birds-Question-About-Life \
		Shoot-Ducks \
		TURKEY \
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
		c yellow; echo "  - core"; c normal
		cd ~/Things/$i/core
		git pull 1>/dev/null
		show_status
		c yellow; echo "  - comps"; c normal
		cd ~/Things/$i/comps
		git pull 1>/dev/null
		show_status

	end

end

