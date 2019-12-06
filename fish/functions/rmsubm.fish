# wengwengweng

function rmsubm -d "remove git submodule" -a "path"

	git config -f .git/config --remove-section submodule.$path
	git config -f .gitmodules --remove-section submodule.$path
	git add .gitmodules
	git rm --cached $path
	rm -rf .git/modules/$path
	rm -rf $path

end

