" wengwengweng

augroup trim
	autocmd BufWritePre * call trim#trim()
augroup END

command! Trim :call trim#trim()
