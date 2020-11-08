" wengwengweng

command! -nargs=* -range Space
			\ call space#start()

augroup Space

	autocmd!

	autocmd BufEnter space
				\ call space#start()

	autocmd BufLeave space
				\ call space#stop()

	autocmd VimLeavePre *
				\ call space#stop()

augroup END

