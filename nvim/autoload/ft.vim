" wengwengweng

func! ft#detect(pat, ft)

	augroup FTDetect
		exec 'autocmd BufNewFile,BufRead ' . a:pat . ' '
					\ . 'setlocal filetype=' . a:ft
	augroup END

endfunc

func! ft#comment(ft, comment, alt)

	let comments = ''

	for c in a:alt
		let comments .= ',b:' . c
	endfor

	augroup FTComment
		exec 'autocmd FileType ' . a:ft . ' '
					\ . 'setlocal commentstring=' . a:comment . '%s'
					\ . ' | '
					\ . 'setlocal comments=b:' . a:comment . comments
	augroup END

endfunc

