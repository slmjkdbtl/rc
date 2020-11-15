# wengwengweng

function git-prompt() {
	# if git
	git rev-parse --is-inside-work-tree &> /dev/null || return 0
	# branch
	if git symbolic-ref -q HEAD &> /dev/null; then
		echo -n "$(git symbolic-ref --short HEAD 2> /dev/null)"
	else
		echo -n "$(git rev-parse --short HEAD 2> /dev/null)"
	fi
	# modified
	git diff-index --quiet HEAD -- &> /dev/null || echo -n "*"
}

