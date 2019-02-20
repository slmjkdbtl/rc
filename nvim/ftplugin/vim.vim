" wengwengweng

inoreabbrev <buffer> <expr> func! <sid>func()
inoreabbrev <buffer> <expr> if <sid>if()
inoreabbrev <buffer> <expr> for <sid>for()

func! s:repeat(ch, num)

	let exp = ''

	for i in range(a:num)
		let exp .= a:ch
	endfor

	return exp

endfunc

func! <sid>func()
	return 'func! endfunc' . s:repeat("\<left>", 8)
endfunc

func! <sid>if()
	return 'if endif' . s:repeat("\<left>", 6)
endfunc

func! <sid>for()
	return 'for endfor' . s:repeat("\<left>", 7)
endfunc

