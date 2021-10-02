func! ft#detect(pat, ft)
	augroup FileTypeDetect
		exec 'autocmd BufNewFile,BufRead ' . a:pat . ' ' . 'setl filetype=' . a:ft
	augroup END
endfunc

func! ft#comment(ft, comment)
	augroup FileTypeComment
		exec 'autocmd FileType ' . a:ft . ' ' . 'setl commentstring=' . a:comment
	augroup END
endfunc
