" wengwengweng

syntax match FBrowseParent
			\ '^..$'
			\ contained
			\ containedin=FBrowseItem

syntax match FBrowseDirHead
			\ '^\(+\|-\)'
			\ contained
			\ containedin=FBrowseDir

syntax match FBrowseMarked
			\ '>\s'
			\ contained
			\ containedin=FBrowseItem

syntax match FBrowseDir
			\ '^\(+\|-\).*'
			\ contained
			\ containedin=FBrowseItem
			\ contains=FBrowseDirHead,FBrowseMarked

syntax match FBrowseItem
			\ '^.*$'
			\ contains=FBrowseDir,FBrowseMarked

highlight def link FBrowseItem
			\ Cleared

highlight def link FBrowseDir
			\ Function

highlight def link FBrowseDirHead
			\ Special

highlight def link FBrowseParent
			\ PreProc

highlight def link FBrowseMarked
			\ String
