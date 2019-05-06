" wengwengweng

syntax match GrepFile
			\ '^=\s.*$'
			\ contains=GrepPos

syntax match GrepPos
			\ ':.*$'
			\ contained
			\ containedin=GrepFile

highlight def link GrepFile
			\ PreProc

highlight def link GrepPos
			\ Special

