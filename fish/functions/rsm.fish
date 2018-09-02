# wengwengweng

function rsm -d "remove git submodule" -a "path"

	test -d "$path"; or return 1
	command git rev-parse --is-inside-work-tree >/dev/null 2>&1; or return 1
	git config -f .git/config --remove-section submodule."$path"
	git config -f .gitmodules --remove-section submodule."$path"
	git add .gitmodules
	git rm --cached "$path"
	rm -rf .git/modules/"$path"
	rm -rf "$path"

end
