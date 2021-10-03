func! trim#trim()
	let save = winsaveview()
	%s/\s\+$//e
	call winrestview(save)
endfunc

func! trim#init()
	augroup Trim
		autocmd!
		autocmd BufWritePre *
					\ call trim#trim()
	augroup END
endfunc
