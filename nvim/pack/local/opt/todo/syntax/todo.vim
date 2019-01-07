" wengwengweng

syntax match TODOComment
			\ '^#.*$'

syntax match TODOItem
			\ '^\s*-.*$'
			\ contains=TODOItemHyphen

syntax match TODOItemHyphen
			\ '^\s*-'
			\ contained
			\ containedin=TODOItem

syntax match TODOTitle
			\ '^==.*$'

highlight def link TODOComment
			\ Comment

highlight def link TODOItemHyphen
			\ Special

highlight def link TODOTitle
			\ Type

