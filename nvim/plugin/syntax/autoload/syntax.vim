" wengwengweng

func! syntax#set(name, comment)

	exec 'setlocal filetype=' . a:name
	exec 'setlocal syntax=' . a:name
	exec 'setlocal commentstring=' . a:comment

endfunc
