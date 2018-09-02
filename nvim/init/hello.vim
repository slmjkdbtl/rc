" wengwengweng

func! s:hello()

	echo 'yo'

	if !argc()
		Space
	endif

endfunc

func! s:bye()

	echo 'bye~'

endfunc

augroup Hello

	autocmd!

	autocmd VimEnter *
				\ :call s:hello()

	autocmd VimLeave *
				\ :call s:bye()

augroup END

