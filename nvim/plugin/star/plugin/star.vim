" wengwengweng

command! -nargs=* -range Star
			\ call star#shine()

augroup Star

	autocmd!
	autocmd BufLeave,BufHidden,BufUnload *
				\ call star#leave()

augroup END

