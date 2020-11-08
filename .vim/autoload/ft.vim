" wengwengweng

let g:ft_registry = {}

func! ft#detect(pat, ft)

	let g:ft_registry[a:ft] = a:pat

	augroup FTDetect
		exec 'autocmd BufNewFile,BufRead ' . a:pat . ' ' . 'setlocal filetype=' . a:ft
	augroup END

endfunc

func! ft#comment(ft, comment, alt)

	let comments = ''

	for c in a:alt
		let comments .= ',b:' . c
	endfor

	augroup FTComment
		exec 'autocmd FileType ' . a:ft . ' ' . 'setlocal commentstring=' . a:comment . '%s' . ' | ' . 'setlocal comments=b:' . a:comment . comments
	augroup END

endfunc

func! ft#for(path)

	for ft in keys(g:ft_registry)
		if path =~ g:ft_registry[ft]
			return ft
		endif
	endfor

	return 0

endfunc

