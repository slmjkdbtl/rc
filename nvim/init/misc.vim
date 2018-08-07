" wengwengweng

augroup hello

	autocmd!
	autocmd VimEnter * if !argc() | Projekt
	autocmd VimLeave * :echo 'bye~'
	autocmd BufEnter * :exec 'lcd ' . expand('%:p:h')

augroup END
