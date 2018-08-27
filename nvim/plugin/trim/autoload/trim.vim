" wengwengweng

func! trim#trim()

	let save = winsaveview()

	%s/\s\+$//e
	call winrestview(save)

endfunc

