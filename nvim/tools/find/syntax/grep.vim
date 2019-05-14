" wengwengweng

syntax match GrepFile
			\ '^=\s.*$'

syntax match GrepLine
			\ '^\d\+:'

highlight def link GrepFile
			\ PreProc

highlight def link GrepLine
			\ Special

highlight def link GrepKeyword
			\ Search

