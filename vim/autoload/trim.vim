func! trim#trim()
	let save = winsaveview()
	%s/\s\+$//e
	call winrestview(save)
endfunc

func! trim#init()
	aug Trim
		au!
		au BufWritePre *
			\ call trim#trim()
	aug END
endfunc
