" wengwengweng

syntax match BrowserParent
			\ '^..$'
			\ contained
			\ containedin=BrowserItem

syntax match BrowserDirHead
			\ '^\(+\|-\)'
			\ contained
			\ containedin=BrowserDir

syntax match BrowserMarked
			\ '>\s'
			\ contained
			\ containedin=BrowserItem

syntax match BrowserDir
			\ '^\(+\|-\).*'
			\ contained
			\ containedin=BrowserItem
			\ contains=BrowserDirHead,BrowserMarked

syntax match BrowserItem
			\ '^.*$'
			\ contains=BrowserDir,BrowserMarked

highlight def link BrowserItem
			\ Cleared

highlight def link BrowserDir
			\ Function

highlight def link BrowserDirHead
			\ Special

highlight def link BrowserParent
			\ PreProc

highlight def link BrowserMarked
			\ String

