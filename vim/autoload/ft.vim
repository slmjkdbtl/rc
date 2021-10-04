func! ft#detect(pat, ft)
	aug FileTypeDetect
		exec 'au BufNewFile,BufRead ' . a:pat . ' ' . 'setl filetype=' . a:ft
	aug END
endfunc

func! ft#comment(ft, comment)
	aug FileTypeComment
		exec 'au FileType ' . a:ft . ' ' . 'setl commentstring=' . a:comment
	aug END
endfunc
