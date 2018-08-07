" wengwengweng

func! s:hello()

	if !argc()
		Projekt
	end

endfunc

func! s:bye()

	echo 'bye~'

endfunc

func! s:autocd()

	exec 'lcd ' . expand('%:p:h')

endfunc

augroup hello

	autocmd!
	autocmd VimEnter * call s:hello()
	autocmd VimLeave * call s:bye()
	autocmd BufEnter * silent! call s:autocd()

augroup END
