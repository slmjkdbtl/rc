" wengwengweng

syntax match DirtyComment
			\ '--.*$'
			\ contains=BrowserDir,BrowserMarked

highlight def link DirtyComment
			\ Comment
