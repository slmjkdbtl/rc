" wengwengweng

if exists("b:current_syntax")
	finish
endif

syn case ignore

syn region dirtAnimName
			\ start='^\s*\[' end='\]'
syn match dirtFrameBorder
			\ '^\s*=\+\s*$'
syn match dirtComment
			\ '^[#;].*$'

hi def link dirtAnimName
			\ Special
hi def link dirtComment
			\ Comment
hi def link dirtFrameBorder
			\ String

let b:current_syntax = "dirt"

