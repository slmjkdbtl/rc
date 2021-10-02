func! autocd#cd()
	let path = expand('%:p')
	if isdirectory(path)
		exec 'lcd ' . path
	elseif filereadable(path)
		exec 'lcd ' . expand('%:p:h')
	endif
endfunc

func! autocd#enable()
	au BufEnter *
		\ call autocd#cd()
endfunc
