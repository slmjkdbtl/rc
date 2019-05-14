" wengwengweng

syntax match GrepFile
			\ '^.\+:\d\+:'

syntax match GrepLine
			\ '\d\+:'
			\ contained

highlight def link GrepFile
			\ Comment

highlight def link GrepLine
			\ Comment

highlight def link GrepKeyword
			\ WildMenu

