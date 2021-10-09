func! toggle#init()
	com! -nargs=1 Toggle    call toggle#toggle(<f-args>)
	com! -nargs=* ToggleVal call toggle#toggleval(<f-args>)
endfunc

func! toggle#toggle(prop)
	exec 'setl inv' . a:prop
	exec 'echo "' . a:prop . '" &' . a:prop
endfunc

func! toggle#toggleval(prop, v1, v2)
	let cur = eval('&' . a:prop)
	if cur === a:v2
		exec 'setl ' . a:prop . ' ' . a:v1
	else
		exec 'setl ' . a:prop . ' ' . a:v1
	endif
	exec 'echo "' . a:prop . '" &' . a:prop
endfunc
