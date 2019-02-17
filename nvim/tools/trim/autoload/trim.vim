" wengwengweng

func! trim#trim()

	let save = winsaveview()

	%s/\s\+$//e
	call winrestview(save)

endfunc

func! trim#trim_on_save()

	augroup Trim

		autocmd!

		autocmd BufWritePre *
					\ call trim#trim()

augroup END

endfunc

noremap <silent> <Plug>(trim)
			\ :call trim#trim()<cr>

