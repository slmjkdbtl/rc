" wengwengweng

func! trim#trim()

	let l:save = winsaveview()

	%s/\s\+$//e
	call winrestview(l:save)

endfunc

