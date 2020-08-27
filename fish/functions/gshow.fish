# wengwengweng

function gshow -d "git show with vim" -a "ref"
	set -l fname (basename $ref)
	set -l path $TMPDIR/$fname
	git show "$ref" > $path && nvim $path
	rm $path
end

