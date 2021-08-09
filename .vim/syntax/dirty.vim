" wengwengweng

syntax match DirtyComment
			\ '--.*$'

syntax region DirtyCommentBlock
			\ start=+---+
			\ end=+---+

highlight def link DirtyComment
			\ Comment

highlight def link DirtyCommentBlock
			\ Comment

