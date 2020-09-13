# wengwengweng

function git-prompt() {
	# if git
	git rev-parse --is-inside-work-tree &> /dev/null || return 0
	# branch
	echo -n $(git symbolic-ref --short HEAD 2> /dev/null)
	# modified
	git diff-index --quiet HEAD -- &> /dev/null || echo -n "*"
}

