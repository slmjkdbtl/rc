" wengwengweng

func! term#toggle()

	if win_gotoid(g:term_win)

		hide

	else

		botright new
		exec 'resize ' . g:term_height

		try

			exec 'buffer ' . g:term_buf
			setlocal nonumber
			setlocal norelativenumber
			setlocal signcolumn=no
			setlocal nobuflisted
			setlocal nocursorline
			setlocal nocursorcolumn
			setlocal nolist
			setlocal norelativenumber
			setlocal nospell
			setlocal colorcolumn=
			setlocal foldcolumn=0
			setlocal matchpairs=
			setlocal noswapfile
			setlocal nowrap
			setlocal nomodifiable
			setlocal nomodified

		catch

			terminal
			let g:term_buf = bufnr('')
			setlocal nonumber
			setlocal norelativenumber
			setlocal signcolumn=no
			setlocal nobuflisted
			setlocal nocursorline
			setlocal nocursorcolumn
			setlocal nolist
			setlocal norelativenumber
			setlocal nospell
			setlocal colorcolumn=
			setlocal foldcolumn=0
			setlocal matchpairs=
			setlocal noswapfile
			setlocal nowrap
			setlocal nomodifiable
			setlocal nomodified

		endtry

		startinsert!
		let g:term_win = win_getid()

	endif

endfunc

nnoremap <silent> <plug>(term_toggle)
			\ :call term#toggle()<cr>

tnoremap <silent> <plug>(term_toggle)
			\ <c-\><c-n>:call term#toggle()<cr>

