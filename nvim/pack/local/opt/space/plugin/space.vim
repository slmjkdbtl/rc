" wengwengweng

command! -nargs=* -range Space
			\ call space#shine()

augroup Space

	autocmd!

	autocmd BufEnter space
				\ call space#start()

	autocmd BufLeave space
				\ call space#stop()

augroup END

