" wengwengweng

syntax match TODOComment
			\ '#.*$'

syntax match TODOItem
			\ '^\s*-.*$'
			\ contains=TODOItemHyphen,TODOItemMark,TODOItemQuestion,TODOItemImportant

syntax match TODOItemMark
			\ '\[.*\]'
			\ contained
			\ containedin=TODOItem

syntax match TODOItemQuestion
			\ '(?)$'
			\ contained
			\ containedin=TODOItem

syntax match TODOItemImportant
			\ '(!)$'
			\ contained
			\ containedin=TODOItem

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

highlight def link TODOItemMark
			\ Comment

highlight def link TODOItemQuestion
			\ Comment

highlight def link TODOItemImportant
			\ Keyword

highlight def link TODOTitle
			\ Type

