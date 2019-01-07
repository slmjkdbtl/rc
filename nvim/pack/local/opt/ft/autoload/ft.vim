" wengwengweng

func! ft#detect(pat, ft)

	augroup Syntax

		autocmd!

		exec 'autocmd BufNewFile,BufRead ' . a:pat . ' '
					\ . 'setlocal filetype=' . a:ft

	augroup END

endfunc

