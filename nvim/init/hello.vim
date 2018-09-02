" wengwengweng

func! s:hello()

	if !argc()
		Space
	endif

endfunc

augroup Hello

	autocmd!

	autocmd VimEnter *
				\ :call s:hello()

augroup END

