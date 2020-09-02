" wengwengweng

if exists("b:current_syntax")
	finish
endif

syn case ignore

syn match ttxComment
			\ '--.*$'

syn match ttxGlobal
			\ '^\s*![^\[]*'

syn match ttxObject
			\ '^\s*#[^\[]*'

syn match ttxStyleItem
			\ '^\s*\.[^\[]*'

syn match ttxStyle
			\ '@[^\]]*'

syn match ttxInline
			\ '\\.'

syn match ttxVariable
			\ '$[^\]]*'

syn match ttxContent
			\ '"[^"]*"'

hi def link ttxComment
			\ Comment

hi def link ttxGlobal
			\ Special

hi def link ttxObject
			\ Type

hi def link ttxStyleItem
			\ Directory

hi def link ttxInline
			\ SpecialChar

hi def link ttxContent
			\ String

hi def link ttxVariable
			\ Keyword

hi def link ttxStyle
			\ Number

let b:current_syntax = "ttx"

