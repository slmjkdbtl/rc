# wengwengweng

function hack -d "hack any website" -a "site"

	if test -n "$site"
		echo "$site hacked"
	else
		c red; echo "please provide website"; c normal
	end

end
