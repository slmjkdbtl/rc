" wengwengweng

func! ft#detect(pat, ft)

	exec 'autocmd BufNewFile,BufRead ' . a:pat . ' '
				\ . 'setlocal filetype=' . a:ft

endfunc

