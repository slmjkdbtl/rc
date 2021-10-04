func! toggle#init()
	com! -nargs=1 Toggle call toggle#toggle(<f-args>)
	com! -nargs=* ToggleVal call toggle#toggleval(<f-args>)
endfunc

func! toggle#toggle(prop)
	exec 'set inv' . a:prop
	exec 'echo "' . a:prop . '" &' . a:prop
endfunc

func! toggle#toggleval(prop, v1, v2)
	" TODO: figure out how to dynamically get setting
	exec 'echo "' . a:prop . '" &' . a:prop
endfunc
