" wengwengweng

func! ft#detect(pat, ft)

	exec 'autocmd BufNewFile,BufRead ' . a:pat . ' '
				\ . 'setlocal filetype=' . a:ft

endfunc

func! ft#comment(pat, com)

	exec 'autocmd BufNewFile,BufRead ' . a:pat . ' '
				\ . 'setlocal commentstring=' . a:com

endfunc

