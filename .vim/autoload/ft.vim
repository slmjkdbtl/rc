func! ft#detect(pat, ft)
	augroup FTDetect
		exec 'autocmd BufNewFile,BufRead ' . a:pat . ' ' . 'setlocal filetype=' . a:ft
	augroup END
endfunc
