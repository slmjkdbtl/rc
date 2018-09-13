" wengwengweng

setlocal commentstring=--\ %s
inoreabbrev <buffer> <expr> function <sid>function()
inoreabbrev <buffer> <expr> do <sid>do()
inoreabbrev <buffer> <expr> then <sid>then()

func! s:repeat(ch, num)

	let exp = ''

	for i in range(a:num)
		let exp .= a:ch
	endfor

	return exp

endfunc

func! <sid>function()

	return 'function end' . s:repeat("\<left>", 4)

endfunc

func! <sid>do()

	let l = getline('.')

	if l =~# '^\s*for\s'
		return 'doend' . s:repeat("\<left>", 3)
	endif

	return 'do'

endfunc

func! <sid>then()

	let l = getline('.')

	if l =~# '^\s*if\s'
		return 'thenend' . s:repeat("\<left>", 3)
	endif

	return 'then'

endfunc

